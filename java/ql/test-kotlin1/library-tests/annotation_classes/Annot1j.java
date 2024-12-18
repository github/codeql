public @interface Annot1j {
    int a() default 2;

    String b() default "ab";

    Class c() default X.class;

    Y d() default Y.A;

    Y[] e() default { Y.A, Y.B };

    Annot0j f() default @Annot0j(
            abc = 1
    );
}