package javax.xml.bind.annotation;

public @interface XmlSchemaType {
    String name();

    String namespace() default "http://www.w3.org/2001/XMLSchema";

    Class type() default DEFAULT.class;

    static final class DEFAULT {};
}


