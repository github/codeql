public class JavaUser {

  public static void test(KotlinAnnotatedMethods km, KotlinDelegate kd) {
    km.f(null);
    kd.notNullAnnotated("Hello world");
  }

}
