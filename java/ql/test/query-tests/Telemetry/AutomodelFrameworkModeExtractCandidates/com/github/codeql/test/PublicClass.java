package com.github.codeql.test;

public class PublicClass {
  public void stuff(String arg) { // arg is a candidate
    System.out.println(arg);
  }

  public static void staticStuff(String arg) { // arg is a candidate
    System.out.println(arg);
  }

  // arg is not a candidate because the method is not public:
  protected void nonPublicStuff(String arg) {
    System.out.println(arg);
  }
}
