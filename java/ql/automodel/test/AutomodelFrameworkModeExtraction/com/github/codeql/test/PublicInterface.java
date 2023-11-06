package com.github.codeql.test;

public interface PublicInterface {
    public void stuff(String arg); // `arg` is a candidate, `this` is a candidate, method stuff is a candidate source, `arg` is a source candidate (overrideable method)

    public static void staticStuff(String arg) { // `arg` is a candidate, `this` is not a candidate (static method)
      System.out.println(arg);
    } // method staticStuff is a candidate source
}
