package com.example;

public class App {
    public static void main(String[] args) {
        var message = "Hello World! Running on Java " + System.getProperty("java.version");
        System.out.println(message);
    }

    public String getMessage() {
        return "Hello from App";
    }
}
