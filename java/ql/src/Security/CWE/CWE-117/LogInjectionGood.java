package com.example.restservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LogInjection {

    private final Logger log = LoggerFactory.getLogger(LogInjection.class);

    // /good?username=Guest'%0AUser:'Admin
    @GetMapping("/good")
    public String good(@RequestParam(value = "username", defaultValue = "name") String username) {
        // The regex check here, allows only alphanumeric characters to pass.
        // Hence, does not result in log injection
        if (username.matches("\\w*")) {
            log.warn("User:'{}'", username);

            return username;
        }
    }
}
