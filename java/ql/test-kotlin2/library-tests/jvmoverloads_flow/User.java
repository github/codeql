public class User {

  public static String source() { return "taint"; }

  public static void test(Test2 t2, GenericTest<Integer> gt, TestDefaultParameterReference paramRefTest) {

    Test.taintSuppliedAsDefault(1, "no taint", 2);
    Test.taintSuppliedAsDefault(1, 2);
    Test.noTaintByDefault(1, source(), 2, 3);
    Test.noTaintByDefault(1, source(), 2);

    Test2.taintSuppliedAsDefaultStatic(1, "no taint", 2);
    Test2.taintSuppliedAsDefaultStatic(1, 2);
    Test2.noTaintByDefaultStatic(1, source(), 2, 3);
    Test2.noTaintByDefaultStatic(1, source(), 2);

    t2.taintSuppliedAsDefault(1, "no taint", 2);
    t2.taintSuppliedAsDefault(1, 2);
    t2.noTaintByDefault(1, source(), 2, 3);
    t2.noTaintByDefault(1, source(), 2);

    gt.taintSuppliedAsDefault(1, "no taint", 2);
    gt.taintSuppliedAsDefault(1, 2);
    gt.noTaintByDefault(1, source(), 2, 3);
    gt.noTaintByDefault(1, source(), 2);

    new ConstructorTaintsByDefault(1, "no taint", 2);
    new ConstructorTaintsByDefault(1, 2);
    new ConstructorDoesNotTaintByDefault(1, source(), 2, 3);
    new ConstructorDoesNotTaintByDefault(1, source(), 2);

    new GenericConstructorTaintsByDefault<Integer>(1, "no taint", 2);
    new GenericConstructorTaintsByDefault<Integer>(1, 2);
    new GenericConstructorDoesNotTaintByDefault<Integer>(1, source(), 2, 3);
    new GenericConstructorDoesNotTaintByDefault<Integer>(1, source(), 2);

    paramRefTest.f(source(), "no flow");
    paramRefTest.f("flow", source());
    paramRefTest.f(source()); // Should also have flow due to the default for the second parameter being the value of the first

  }

}
