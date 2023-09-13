package com.github.codeql.test;

import java.nio.file.Paths;

public class PublicClass {
  public void stuff(String arg) {
    System.out.println(arg);
  }

  public static void staticStuff(String arg) {
    System.out.println(arg);
  }

  protected void nonPublicStuff(String arg) {
    System.out.println(Paths.get("foo", arg));
  }

  void packagePrivateStuff(String arg) {
    System.out.println(arg);
  }
}
