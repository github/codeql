package org.checkerframework.checker.nullness.qual;
import java.lang.annotation.Target;
import java.lang.annotation.ElementType;

@Target({ElementType.TYPE_USE, ElementType.TYPE_PARAMETER})
public @interface NonNull {}