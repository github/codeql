package com.github.codeql.test;

public class PublicClass {
  public void stuff(String arg) { // $ sinkModelCandidate=stuff(String):Argument[this] sourceModelCandidate=stuff(String):Parameter[this] sinkModelCandidate=stuff(String):Argument[0] sourceModelCandidate=stuff(String):Parameter[0] // source candidates because it is an overrideable method
    System.out.println(arg);
  }

  public static void staticStuff(String arg) { // $ sinkModelCandidate=staticStuff(String):Argument[0] // `arg` is not a source candidate (not overrideabe); `this` is not a candidate (static method)
    System.out.println(arg);
  }

  protected void nonPublicStuff(String arg) { // $ sinkModelCandidate=nonPublicStuff(String):Argument[this] sourceModelCandidate=nonPublicStuff(String):Parameter[this] sinkModelCandidate=nonPublicStuff(String):Argument[0] sourceModelCandidate=nonPublicStuff(String):Parameter[0]
    System.out.println(arg);
  }

  void packagePrivateStuff(String arg) { // no candidates because the method is not public
    System.out.println(arg);
  }

  public PublicClass(Object input) { // $ sourceModelCandidate=PublicClass(Object):ReturnValue sinkModelCandidate=PublicClass(Object):Argument[0] // `this` is not a candidate because it is a constructor
  }

   // `input` and `input` are source candidates, but not sink candidates (is-style method)
  public Boolean isIgnored(Object input) { // $ negativeSinkExample=isIgnored(Object):Argument[this] sourceModelCandidate=isIgnored(Object):Parameter[this] negativeSinkExample=isIgnored(Object):Argument[0] sourceModelCandidate=isIgnored(Object):Parameter[0]
    return false;
  }
}
