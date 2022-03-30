import java.lang.SuppressWarnings;

public class AnnotationTest {
  @SuppressWarnings("unchecked")
  public static class AnnotatedClass {
  }

  public static void main(String[] args) {
    AnnotatedClass.class.getAnnotation(SuppressWarnings.class);
  }
}
