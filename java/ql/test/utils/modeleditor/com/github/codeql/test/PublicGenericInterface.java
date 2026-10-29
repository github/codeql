package com.github.codeql.test;

public interface PublicGenericInterface<T> {
    public void stuff(T arg);
    public <T2> void stuff2(T2 arg);

    public static void staticStuff(String arg) {
      System.out.println(arg);
    }
}
