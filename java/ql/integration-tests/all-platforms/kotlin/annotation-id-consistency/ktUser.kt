public class KtUser {

  fun user() {
    val a = AnnotatedUsedByKotlin()
    val b = HasJavaDeprecatedAnnotationUsedByKotlin()
    val c = HasKotlinDeprecatedAnnotationUsedByKotlin()
    // Use a Java-defined function carrying a java.lang.Deprecated annotation:
    java.lang.Character.isJavaLetter('a')
  }

}
