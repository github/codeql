package com.github.codeql.test;

import java.nio.file.FileSystems;
import java.nio.file.Paths;

public class PublicClass {
  public void stuff(String arg) {
    System.out.println(arg);
  }

  public static void staticStuff(String arg) {
    System.out.println(arg);
  }

  protected void protectedStuff(String arg) {
    System.out.println(Paths.get("foo", arg));
  }

  private void privateStuff(String arg) {
    System.out.println(FileSystems.getDefault().getPath("foo", arg));
  }

  void packagePrivateStuff(String arg) {
    System.out.println(arg);
  }

  public String summaryStuff(String arg) {
    return arg;
  }

  public String sourceStuff() {
    return "stuff";
  }

  public void sinkStuff(String arg) {
    // do nothing
  }

  public void neutralStuff(String arg) {
    // do nothing
  }
}
