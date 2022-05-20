package my.qltest;

public class C {
  void foo() {
    Object arg1 = new Object();
    stepArgRes(arg1);

    Object argIn1 = new Object();
    Object argOut1 = new Object();
    stepArgArg(argIn1, argOut1);
    Object argIn2 = new Object();
    Object argOut2 = new Object();
    stepArgArg(argIn2, argOut2);

    Object arg2 = new Object();
    stepArgQual(arg2);
    Object arg3 = new Object();
    this.stepArgQual(arg3);

    this.stepQualRes();
    stepQualRes();

    Object argOut = new Object();
    stepQualArg(argOut);
  }

  void fooGenerated() {
    Object arg1 = new Object();
    stepArgResGenerated(arg1);

    Object arg2 = new Object();
    // The summary for the first parameter is ignored, because it is generated and
    // because there is hand written summary for the second parameter.
    stepArgResGeneratedIgnored(arg1, arg2);
  }

  Object stepArgRes(Object x) { return null; }

  void stepArgArg(Object in, Object out) { }

  void stepArgQual(Object x) { }

  Object stepQualRes() { return null; }

  void stepQualArg(Object out) { }

  Object stepArgResGenerated(Object x) { return null; }

  Object stepArgResGeneratedIgnored(Object x, Object y) { return null; }
}
