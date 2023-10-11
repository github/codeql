package com.github.codeql.test;

public interface PublicInterface {
    public void stuff(String arg);

    public static void staticStuff(String arg) {
      System.out.println(arg);
    }
}
