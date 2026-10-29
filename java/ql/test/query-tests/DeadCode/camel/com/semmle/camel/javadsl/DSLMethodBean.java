package com.semmle.camel.javadsl;

/** A bean referred to in the CustomRouteBuilder. */
public class DSLMethodBean {
  public Foo getFoo(Foo foo1) {
    return new Foo();
  }

  public static class Foo {}
}
