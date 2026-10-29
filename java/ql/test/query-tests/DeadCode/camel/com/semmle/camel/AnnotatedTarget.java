package com.semmle.camel;

import org.apache.camel.Consume;

/** Class is live because it is constructed as a bean. Method is live because it is annotated. */
public class AnnotatedTarget {

  @Consume(uri = "activemq:test")
  public Foo getFoo(Foo foo1) {
    return new Foo();
  }

  public static class Foo {}
}
