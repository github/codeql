public class Test {

  // This gets mapped to kotlin.Iterable<out T>, meaning we must reintroduce the use-site extends variance to get a type consistent with Java.
  public static void needlessExtends(Iterable<? extends String> l) { }

  // This type is defined KotlinConsumer<in T>, meaning we must reintroduce the use-site extends variance to get a type consistent with Java.
  public static void needlessSuper(KotlinConsumer<? super Object> l) { }

}
