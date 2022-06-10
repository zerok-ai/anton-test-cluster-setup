import { check } from 'k6';
import http from 'k6/http';
import { sleep } from 'k6';
import { Counter, Trend } from 'k6/metrics';

/* scenario specs */
const preallocVUs = 2000;
const maxVUs = 2000;
const timeUnit = '1m';

const scenarioStages = {
/*/
  'highmem' : [
    { duration: '1m', target:  800 },
    { duration: '3m', target:  800 },
    { duration: '30s', target:  800 }  
  ],
/*/
  'highcpu' : [
    { duration: '1m', target: 500 },
    { duration: '2m', target: 1000 },
    { duration: '2m', target: 1200 },
    { duration: '4m', target: 1200 },
  ],
/*/
  'highmem1' : [
    { duration: '1m', target: 1500 },
    { duration: '3m', target: 1500 },
    { duration: '30s', target: 1500 }  
  ],
/*/
  'highcpu1' : [
    { duration: '1m', target: 500 },
    { duration: '2m', target: 1000 },
    { duration: '2m', target: 1200 },
    { duration: '4m', target: 1200 },
  ],
/*/	
  'highload' : [
    { duration: '1m', target: 10000 },
    { duration: '3m', target: 10000 },
    { duration: '30s', target: 10000 }
  ],
//
  'lowload' : [
    { duration: '1m', target: 1000 },
    { duration: '3m', target: 1000 },
    { duration: '30s', target: 1000 }  
  ]
/**/
}

const verticalScaleCount = {
  // Count variable to control Mem consumed by each highmem API call.
  'highmem': 15,  // 1 * 1MB
  'highmem1': 15,  // 1 * 1MB
   // Count variable to control CPU consumed by each highcpu API call.
  'highcpu': 333 * 1000,
  'highcpu1': 333 * 1000
}

const scenarioMetrics = ['waiting', 'duration']

/* End scenario specs */

// const customCounter = new Counter(    {
//   name: 'k6_test_setup',
//   help: 'K6s Test status',
//   labelNames: ['code']
// });

// export function setup() {
//   // 2. setup code
//   customCounter.inc(verticalScaleCount);
// }

// export function teardown(data) {
//   // 4. teardown code
//   customCounter.dec(verticalScaleCount);
// }

var myTrend = {};

function generateScenarioObj(scenarioName) {
  return {
    executor: 'ramping-arrival-rate',
    exec: scenarioName,
    preAllocatedVUs: preallocVUs,
    timeUnit,
    maxVUs,
    // rate: scenarioStages[scenarioName][0].target,
    startRate: scenarioStages[scenarioName][0].target,
    stages: scenarioStages[scenarioName]
  }
}

function generateScenarios() {
  var scenarios = {};
  Object.keys(scenarioStages).forEach(element => {
    scenarioMetrics.forEach((metric) => {
	myTrend[element] = myTrend[element] || {};
    	myTrend[element][metric] = new Trend(`custom_${element}_${metric}`);
    })
    module.exports[element] = prepareExecFn(element);
    scenarios[element] = generateScenarioObj(element);
  });
  return scenarios;
}

export const options = {
  noConnectionReuse: true,
  scenarios: generateScenarios(),
  VUs: preallocVUs,
  ext: {
    loadimpact: {
      apm: [
        {
          provider: 'prometheus',
          remoteWriteURL: 'http://localhost:9090/api/v1/write',
          includeDefaultMetrics: true,
          includeTestRunId: true,
          resampleRate: 3,
        },
      ],
    },
  },
};

const hostname = __ENV.MY_HOSTNAME;

function prepareExecFn(scenarioName) {
  return () => {
    const res = http.get('http://'+hostname+'/app/'+scenarioName+'?count='+verticalScaleCount[scenarioName]);
    check(res, {
      'verify homepage text': (r) =>
        r.body.includes(scenarioName),
    });
    scenarioMetrics.forEach((metric) => {
    	myTrend[scenarioName][metric].add(res.timings[metric], {tag: `${scenarioName}_${metric}`});
    })
    sleep(1);  
  }
}
