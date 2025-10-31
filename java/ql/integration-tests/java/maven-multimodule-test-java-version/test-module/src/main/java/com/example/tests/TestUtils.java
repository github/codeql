package com.example.tests;

// Requires Java 21: switch with pattern matching and guards
public class TestUtils {
    public static String analyze(Object obj) {
        return switch (obj) {
            case String s when s.length() > 5 -> "long";
            case String s -> "short";
            default -> "other";
        };
    }
}