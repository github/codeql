package com.github.codeql.test;

public interface PublicInterface {
    public void stuff(String arg); // `arg` is a candidate, `this` is a candidate

    public static void staticStuff(String arg) { // `arg` is a candidate, `this` is not a candidate (static method)
      System.out.println(arg);
    }
}
