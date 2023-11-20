package com.github.codeql.test;

public interface PublicInterface {
    public int stuff(String arg); // `arg` is a candidate, `this` is a candidate, method stuff is _not_ a candidate source (primitive return type), `arg` is a source candidate (overridable method)

    public static void staticStuff(String arg) { // `arg` is a candidate, `this` is not a candidate (static method)
      System.out.println(arg);
    }
}
