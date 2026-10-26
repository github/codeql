package com.github.codeql.test;

import java.nio.file.Paths;

public class PublicGenericClass<T, T2> implements PublicGenericInterface<T> {
  public void stuff(T arg) {
    System.out.println(arg);
  }

  public <T3> void stuff2(T3 arg) {
    System.out.println(arg);
  }
}
