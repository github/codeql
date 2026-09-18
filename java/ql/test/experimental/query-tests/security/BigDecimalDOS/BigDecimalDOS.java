package com.example.servingwebcontent;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.math.MathContext;

@Controller
public class GreetingController {
	@GetMapping("/tonghuaroot-DOSDemo01")
	@ResponseBody
    // BAD:
	public Long demo(@RequestParam(name = "num") BigDecimal num) {
		Long startTime = System.currentTimeMillis();
		BigDecimal num1 = new BigDecimal(0.005);
		System.out.println(num1.add(num));
		Long endTime = System.currentTimeMillis();
		Long tempTime = (endTime - startTime);
		System.out.println(tempTime);
		return tempTime;
	}

    @GetMapping("/tonghuaroot-DOSDemo02")
	@ResponseBody
    // GOOD:
	public Long demo02(@RequestParam(name = "num") String num) {
        if (num.length() > 33 || num.matches("(?i)e")) { 
            return "Input Parameter is too long."
        }
		Long startTime = System.currentTimeMillis();
		BigDecimal num1 = new BigDecimal(0.005);
		System.out.println(num1.add(num));
		Long endTime = System.currentTimeMillis();
		Long tempTime = (endTime - startTime);
		System.out.println(tempTime);
		return tempTime;
	}
}