package com.github.codeql.test;

public class PublicClass {
  public void stuff(String arg) { // `arg` is a sink candidate, `this` is a candidate, `arg` is a source candidate (overrideable method)
    System.out.println(arg);
  }

  public static void staticStuff(String arg) { // `arg` is a sink candidate, but not a source candidate (not overrideabe); `this` is not a candidate (static method)
    System.out.println(arg);
  }

  // `arg` and `this` are candidates because the method is protected (may be called from downstream repositories). The return value is a candidate source for the same reason.
  protected void nonPublicStuff(String arg) {
    System.out.println(arg);
  }

  // `arg` and `this are not candidates because the method is not public:
  void packagePrivateStuff(String arg) {
    System.out.println(arg);
  }

  public PublicClass(Object input) {
    // the `this` qualifier is not a candidate
  }

  public Boolean isIgnored(Object input) { // `input` is a source candidate, but not a sink candidate (is-style method); `this` is not a candidate
    return false;
  }
}
