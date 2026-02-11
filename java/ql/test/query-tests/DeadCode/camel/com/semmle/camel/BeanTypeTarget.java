package com.semmle.camel;

/**
 * All public methods in this class are considered to be live because this class is registered in a
 * {@code <bean beanType="...">} tag in a Spring XML defined route.
 */
public class BeanTypeTarget {
  public Foo applyFoo(Foo foo1) {
    return new Foo();
  }

  public static class Foo {}
}
