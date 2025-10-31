package com.example;

public class AppTest {
    public static void main(String[] args) {
        App app = new App();
        String message = app.getMessage();

        if ("Hello from App".equals(message)) {
            System.out.println("Test passed!");
        } else {
            System.err.println("Test failed!");
            System.exit(1);
        }
    }
}
