public class Test<T> {

  public T field;
  public T method() { return field; }

}

class FieldUsed {}
class MethodUsed {}
class ConstructorUsed {}
class NeitherUsed {} 

class User {

  public static void test(Test<NeitherUsed> neitherUsed, Test<MethodUsed> methodUsed, Test<FieldUsed> fieldUsed) { 

    fieldUsed.field = null;
    methodUsed.method();
    Test<ConstructorUsed> constructorUsed = new Test<ConstructorUsed>();

  }

}
