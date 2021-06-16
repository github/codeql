package com.example.demo;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoApplication {

    @GetMapping("/string1")
    public String string1(@RequestParam(value = "input", defaultValue = "test") String input,
                          @RequestParam(value = "pattern", defaultValue = ".*") String pattern) {
        // BAD: Unsanitized user input is used to construct a regular expression
        if (input.matches("^" + pattern + "=.*$"))
            return "match!";

        return "doesn't match!";
    }

    @GetMapping("/string2")
    public String string2(@RequestParam(value = "input", defaultValue = "test") String input,
                          @RequestParam(value = "pattern", defaultValue = ".*") String pattern) {
        // GOOD: User input is sanitized before constructing the regex
        if (input.matches("^" + escapeSpecialRegexChars(pattern) + "=.*$"))
            return "match!";

        return "doesn't match!";
    }

    Pattern SPECIAL_REGEX_CHARS = Pattern.compile("[{}()\\[\\]><-=!.+*?^$\\\\|]");

    String escapeSpecialRegexChars(String str) {
        return SPECIAL_REGEX_CHARS.matcher(str).replaceAll("\\\\$0");
    }
}