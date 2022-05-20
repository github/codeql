package com.example.restservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LogInjection {

    private final Logger log = LoggerFactory.getLogger(LogInjection.class);

    // /bad?username=Guest'%0AUser:'Admin
    @GetMapping("/bad")
    public String bad(@RequestParam(value = "username", defaultValue = "name") String username) {
        log.warn("User:'{}'", username);
        // The logging call above would result in multiple log entries as shown below:
        // User:'Guest'
        // User:'Admin'
        return username;
    }
}

