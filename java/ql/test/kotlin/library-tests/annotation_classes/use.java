
public class use implements SomeAnnotation {
    @Override
    public int abc() { return 1; }
    @Override
    public String y() { return ""; }

    @Override
    public Class<? extends java.lang.annotation.Annotation> annotationType() {
        return null;
    }
}
