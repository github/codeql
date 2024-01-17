package com.github.codeql.test;

public interface PublicInterface {
    public int stuff(String arg); // $ sinkModel=stuff(String):Argument[this] sourceModel=stuff(String):Parameter[this] sinkModel=stuff(String):Argument[0] sourceModel=stuff(String):Parameter[0]  // result is _not_ a source candidate source (primitive return type)

    public static void staticStuff(String arg) { // $ sinkModel=staticStuff(String):Argument[0] // not a source candidate (static method)
      System.out.println(arg);
    }
}
