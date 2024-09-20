package com.github.codeql.test;

public interface PublicInterface {
    public int stuff(String arg); // $ sinkModelCandidate=stuff(String):Argument[this] sourceModelCandidate=stuff(String):Parameter[this] sinkModelCandidate=stuff(String):Argument[0] sourceModelCandidate=stuff(String):Parameter[0]  // result is _not_ a source candidate source (primitive return type)

    public static void staticStuff(String arg) { // $ sinkModelCandidate=staticStuff(String):Argument[0] // not a source candidate (static method)
      System.out.println(arg);
    }
}
