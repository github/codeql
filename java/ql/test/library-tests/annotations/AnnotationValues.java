class AnnotationValues {
    private static final byte BYTE = 2;
    private static final short SHORT = 2;
    private static final int INT = 2;
    private static final long LONG = 2;
    private static final float FLOAT = 2;
    private static final double DOUBLE = 2;
    private static final boolean BOOLEAN = true;
    private static final char CHAR = 'b';

    private static final String STRING = "b";

    enum CustomEnum {
        DEFAULT,
        A,
        B
    }

    @interface CustomAnnotation {
        String value();
    }

    @interface SingleValues {
        byte byteValue() default -1;
        short shortValue() default -1;
        int intValue() default -1;
        long longValue() default -1;
        float floatValue() default -1;
        double doubleValue() default -1;
        boolean booleanValue() default false;
        char charValue() default '\uFFFF';

        String stringValue() default "\0";
        Class<?> classValue() default AnnotationValues.class;
        CustomEnum enumValue() default CustomEnum.DEFAULT;
        CustomAnnotation annotationValue() default @CustomAnnotation("default");
    }

    @SingleValues
    private int singleValuesDefault;

    @SingleValues(
        byteValue = 1,
        shortValue = 1,
        intValue = 1,
        longValue = 1,
        floatValue = 1,
        doubleValue = 1,
        booleanValue = true,
        charValue = 1,
        stringValue = "a",
        classValue = SingleValues.class,
        enumValue = CustomEnum.A,
        annotationValue = @CustomAnnotation("single")
    )
    private int singleValues;

    @SingleValues(
        byteValue = BYTE,
        shortValue = SHORT,
        intValue = INT,
        longValue = LONG,
        floatValue = FLOAT,
        doubleValue = DOUBLE,
        booleanValue = BOOLEAN,
        charValue = CHAR,
        stringValue = STRING,
        classValue = SingleValues.class,
        enumValue = CustomEnum.A,
        annotationValue = @CustomAnnotation("single")
    )
    private int singleValuesConstants;

    @interface ArrayValues {
        byte[] byteValues() default -1;
        short[] shortValues() default -1;
        int[] intValues() default -1;
        long[] longValues() default -1;
        float[] floatValues() default -1;
        double[] doubleValues() default -1;
        boolean[] booleanValues() default false;
        char[] charValues() default '\uFFFF';

        String[] stringValues() default "\0";
        Class<?>[] classValues() default AnnotationValues.class;
        CustomEnum[] enumValues() default CustomEnum.DEFAULT;
        CustomAnnotation[] annotationValues() default @CustomAnnotation("default");
    }

    @ArrayValues
    private int arrayValuesDefault;

    @ArrayValues(
        byteValues = 1,
        shortValues = 1,
        intValues = 1,
        longValues = 1,
        floatValues = 1,
        doubleValues = 1,
        booleanValues = true,
        charValues = 'a',
        stringValues = "a",
        classValues = ArrayValues.class,
        enumValues = CustomEnum.A,
        annotationValues = @CustomAnnotation("single")
    )
    private int arrayValuesSingleExpr;

    @ArrayValues(
        byteValues = {1, BYTE},
        shortValues = {1, SHORT},
        intValues = {1, INT},
        longValues = {1, LONG},
        floatValues = {1, FLOAT},
        doubleValues = {1, DOUBLE},
        booleanValues = {false, BOOLEAN},
        charValues = {'a', CHAR},
        stringValues = {"a", "b"},
        classValues = {SingleValues.class, ArrayValues.class},
        enumValues = {CustomEnum.A, CustomEnum.B},
        annotationValues = {@CustomAnnotation("first"), @CustomAnnotation("second")}
    )
    private int arrayValues;
}
