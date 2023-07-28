package com.github.codeql.test;

public class PublicClass {
  public void stuff(String arg) { // `arg` is a candidate, `this` is a candidate
    System.out.println(arg);
  }

  public static void staticStuff(String arg) { // `arg` is a candidate, `this` is not a candidate (static method)
    System.out.println(arg);
  }

  // `arg` and `this` are not a candidate because the method is not public:
  protected void nonPublicStuff(String arg) {
    System.out.println(arg);
  }

  // `arg` and `this are not candidates because the method is not public:
  void packagePrivateStuff(String arg) {
    System.out.println(arg);
  }
}
