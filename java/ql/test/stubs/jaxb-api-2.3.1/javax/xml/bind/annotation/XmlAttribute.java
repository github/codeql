package javax.xml.bind.annotation;

public @interface XmlAttribute {
    String name() default "##default";
 
     boolean required() default false;

    String namespace() default "##default" ;
}