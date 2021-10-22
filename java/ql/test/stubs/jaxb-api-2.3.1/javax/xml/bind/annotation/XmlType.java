package javax.xml.bind.annotation;

public @interface XmlType {
    String name() default "##default" ;
 
    String[] propOrder() default {""};

    String namespace() default "##default" ;
   
    Class factoryClass() default DEFAULT.class;

    static final class DEFAULT {}

    String factoryMethod() default "";
}

