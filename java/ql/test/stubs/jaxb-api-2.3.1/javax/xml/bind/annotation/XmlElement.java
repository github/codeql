package javax.xml.bind.annotation;

public @interface XmlElement {
    String name() default "##default";

    boolean nillable() default false;

    boolean required() default false;

    String namespace() default "##default";

    String defaultValue() default "\u0000";

    Class type() default DEFAULT.class;

    static final class DEFAULT {};
}
