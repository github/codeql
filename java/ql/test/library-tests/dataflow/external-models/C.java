package my.qltest;

import my.qltest.external.Library;

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
    Object arg = new Object();

    // The (generated) summary is ignored because the source code is available.
    stepArgResGenerated(arg);
  }

  // Library functionality is emulated by placing the source code in a "stubs"
  // folder. This means that a generated summary will be applied, if there
  // doesn't exist a manual summary or manual summary neutral.
  void fooLibrary() {
    Object arg1 = new Object();

    Library lib = new Library();

    lib.apiStepArgResGenerated(arg1);

    Object arg2 = new Object();

    // The summary for the first parameter is ignored, because it is generated and
    // because there is a manual summary for the second parameter.
    lib.apiStepArgResGeneratedIgnored(arg1, arg2);

    lib.apiStepArgQualGenerated(arg1);

    // The summary for the parameter is ignored, because it is generated and
    // because there is a manual neutral summary model for this callable.
    lib.apiStepArgQualGeneratedIgnored(arg1);

    lib.getValue();
  }

  void fooPossibleLibraryDispatch(Library lib) {
    Object arg1 = new Object();

    lib.id(arg1);
  }

  void fooExplicitDispatch() {
    Object arg1 = new Object();

    MyLibrary lib = new MyLibrary();

    lib.id(arg1);
  }

  void fooGeneric(MyGenericLibrary<String> lib) {
    lib.get();
  }

  Object stepArgRes(Object x) {
    return null;
  }

  void stepArgArg(Object in, Object out) {}

  void stepArgQual(Object x) {}

  Object stepQualRes() {
    return null;
  }

  void stepQualArg(Object out) {}

  Object stepArgResGenerated(Object x) {
    return null;
  }

  class MyLibrary extends Library {
    @Override
    // Bad implementation of the id function.
    public Object id(Object x) {
      return null;
    }
  }

  public class MyGenericLibrary<T> {
    public T get() {
      return null;
    }
  }
}
