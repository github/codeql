package com.github.codeql.test;

public class PublicClass {
  public void stuff(String arg) { // `arg` is a sink candidate, `this` is a candidate, `arg` is a source candidate (overrideable method)
    System.out.println(arg);
  } // method stuff is a candidate source

  public static void staticStuff(String arg) { // `arg` is a candidate, `this` is not a candidate (static method), `arg` is not a source candidate (static methods can not be overloaded)
    System.out.println(arg);
  } // method staticStuff is a candidate source

  // `arg` and `this` are not a candidate because the method is not public:
  protected void nonPublicStuff(String arg) {
    System.out.println(arg);
  }

  // `arg` and `this are not candidates because the method is not public:
  void packagePrivateStuff(String arg) {
    System.out.println(arg);
  }
}
