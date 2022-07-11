public class ReadsFields {

  public static void read() {

    sink(HasFields.constField);
    sink(HasFields.lateinitField);
    sink(HasFields.jvmFieldAnnotatedField);

  }

  public static void sink(String x) { }

}
