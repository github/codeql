package com.example.controller.test;

import java.net.URL;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestDirController {

    @GetMapping(value = "TestDir")
    public void bad3(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("TestDir");
    }
}
