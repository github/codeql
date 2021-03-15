package com.example.controller;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestController {

    @GetMapping(value = "testMysql")
    public void bad1(HttpServletRequest request, HttpServletResponse response){
        System.out.println("testMysql");
    }

    @GetMapping(value = "urlTest")
    public void bad2(HttpServletRequest request, HttpServletResponse response){
        System.out.println("urlTest");
    }

    @GetMapping(value = "Testxxx")
    public void bad3(HttpServletRequest request, HttpServletResponse response){
        System.out.println("Testxxx");
    }
}
