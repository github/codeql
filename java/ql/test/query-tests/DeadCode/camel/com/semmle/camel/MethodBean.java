package com.semmle.camel;

/** A bean referred to in a method element in the config.xml file. */
public class MethodBean {
  public Foo getFoo(Foo foo1) {
    return new Foo();
  }

  public static class Foo {}
}
