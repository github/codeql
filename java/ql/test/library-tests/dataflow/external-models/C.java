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

  Object stepArgRes(Object x) { return null; }

  void stepArgArg(Object in, Object out) { }

  void stepArgQual(Object x) { }

  Object stepQualRes() { return null; }

  void stepQualArg(Object out) { }
}
