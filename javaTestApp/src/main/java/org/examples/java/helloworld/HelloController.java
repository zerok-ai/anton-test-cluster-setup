package org.examples.java.helloworld;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {
    
    @RequestMapping("/")
    public String index() {
        return "Hello Jenkins X + Spring Boot!";
    }

    @RequestMapping("/highmem")
    public String highmemHandler() {
        return "highmem API";
    }

    @RequestMapping("/highcpu")
    public String highcpuHandler() {
        return "highcpu API";
    }

    @RequestMapping("/highload")
    public String highloadHandler() {
        return "highload API";
    }

    @RequestMapping("/lowload")
    public String lowloadHandler() {
        return "lowload API";
    }

    @RequestMapping("/hc")
    public String hcHandler() {
        return "hc API";
    }

}
