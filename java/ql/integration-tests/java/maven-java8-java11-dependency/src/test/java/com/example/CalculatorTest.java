package com.example;

import org.testng.Assert;
import org.testng.annotations.Test;

/**
 * Test class using TestNG 7.7.0 which requires Java 11+.
 */
public class CalculatorTest {
    @Test
    public void testAdd() {
        Calculator calc = new Calculator();
        Assert.assertEquals(calc.add(2, 3), 5);
    }

    @Test
    public void testMultiply() {
        Calculator calc = new Calculator();
        Assert.assertEquals(calc.multiply(3, 4), 12);
    }
}
