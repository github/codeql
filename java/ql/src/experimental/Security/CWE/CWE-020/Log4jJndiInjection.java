package com.example.restservice;

import org.apache.commons.logging.log4j.Logger;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Log4jJndiInjection {

    private final Logger logger = LogManager.getLogger();

    @GetMapping("/bad")
    public String bad(@RequestParam(value = "username", defaultValue = "name") String username) {
        logger.warn("User:'{}'", username);
        return username;
    }
}
