package com.example;

import java.util.List;

/**
 * Simple class using Java 16 features (e.g.,records).
 */
public class App {
    public static void main(String[] args) {
        Person person = new Person("Bob", 42);
        System.out.println(person);
    }
}

record Person(String name, int age) {}
