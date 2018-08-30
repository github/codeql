import java.util.*;

public class DeadEnumConstantTest {

  public @interface MyAnnotation{};

  public static enum E1{
    unused1,
    unused2,

    @MyAnnotation
    ok1,                                  // constants with reflective annotations should be ignored

    ok2, ok3, ok4, ok5,
  }

  @MyAnnotation
  public static enum Ignore{ ok1, ok2, ok3; }

  public static void main(String[] args){
    method1(E1.unused1 == E1.unused2);   // does not count as use, since constants can't be stored this way
    method2(E1.ok2);                     // constant could potentially be stored
    method2(1 != 2 ? E1.ok3 : E1. ok4);
    method3();
  }

  public static void method1(boolean a){}
  public static void method2(E1 e1){}

  public static E1 method3(){
    return E1.ok5;                      // returns constant, which could possibly be stored by the caller
  }

}
