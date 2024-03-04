public class use implements Annot0k {
    @Override
    public int a() { return 1; }

    @Override
    public Class<? extends java.lang.annotation.Annotation> annotationType() {
        return null;
    }

    @Annot0j(abc = 1)
    @Annot1j(a = 1, b = "ac", c = X.class, d = Y.B, e = {Y.C, Y.A}, f = @Annot0j(abc = 2))
    @Annot0k(a = 1)
    @Annot1k(a = 1, b = "ac", c = X.class, d = Y.B, e = {Y.C, Y.A}, f = @Annot0k(a = 2))
    public class Z { }
}
