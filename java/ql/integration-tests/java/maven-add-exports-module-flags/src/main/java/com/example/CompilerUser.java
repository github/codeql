package com.example;

import com.sun.tools.javac.api.JavacTool;

/**
 * Simple class that uses JDK compiler internals.
 * This requires --add-exports flags to compile.
 */
public class CompilerUser {
    public static void main(String[] args) {
        // Use JavacTool from jdk.compiler module
        JavacTool tool = JavacTool.create();
        System.out.println("Compiler tool: " + tool.getClass().getName());
    }
}
