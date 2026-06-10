package com.semmle.camel;

/** Dead because it is not referenced in the {@code config.xml} file, or in the Java DSL. */
public class DeadTarget { // $ Alert[java/dead-class]
  public Foo getFoo(Foo foo1) {
    return new Foo();
  }

  public static class Foo {} // $ Alert[java/dead-class]
}
