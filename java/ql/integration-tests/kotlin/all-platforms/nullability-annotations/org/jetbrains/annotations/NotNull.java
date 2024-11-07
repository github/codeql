package org.jetbrains.annotations;

public @interface NotNull {
  String value() default "";
  Class<? extends Exception> exception() default Exception.class;
}
