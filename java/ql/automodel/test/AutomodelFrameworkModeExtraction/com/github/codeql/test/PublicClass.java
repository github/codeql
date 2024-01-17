package com.github.codeql.test;

public class PublicClass {
  public void stuff(String arg) { // $ sinkModel=stuff(String):Argument[this] sourceModel=stuff(String):Parameter[this] sinkModel=stuff(String):Argument[0] sourceModel=stuff(String):Parameter[0] // source candidates because it is an overrideable method
    System.out.println(arg);
  }

  public static void staticStuff(String arg) { // $ sinkModel=staticStuff(String):Argument[0] // `arg` is not a source candidate (not overrideabe); `this` is not a candidate (static method)
    System.out.println(arg);
  }

  protected void nonPublicStuff(String arg) { // $ sinkModel=nonPublicStuff(String):Argument[this] sourceModel=nonPublicStuff(String):Parameter[this] sinkModel=nonPublicStuff(String):Argument[0] sourceModel=nonPublicStuff(String):Parameter[0]
    System.out.println(arg);
  }

  void packagePrivateStuff(String arg) { // no candidates because the method is not public
    System.out.println(arg);
  }

  public PublicClass(Object input) { // $ sourceModel=PublicClass(Object):ReturnValue sinkModel=PublicClass(Object):Argument[0] // `this` is not a candidate because it is a constructor
  }

   // `input` and `input` are source candidates, but not sink candidates (is-style method)
  public Boolean isIgnored(Object input) { // $ negativeExample=isIgnored(Object):Argument[this] sourceModel=isIgnored(Object):Parameter[this] negativeExample=isIgnored(Object):Argument[0] sourceModel=isIgnored(Object):Parameter[0]
    return false;
  }
}
