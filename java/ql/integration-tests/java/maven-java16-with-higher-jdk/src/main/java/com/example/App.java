package com.example;

import java.util.List;

/**
 * Simple class using Java 16 features (like records).
 */
public class App {
    public static void main(String[] args) {
        Person person = new Person("Alice", 30);
        System.out.println(person);
        
        var numbers = List.of(1, 2, 3, 4, 5);
        System.out.println("Numbers: " + numbers);
    }
}

record Person(String name, int age) {}
