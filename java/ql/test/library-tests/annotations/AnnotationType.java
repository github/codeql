import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Repeatable;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

class AnnotationType {
    @Inherited
    @interface InheritedAnnotation {}

    @Documented
    @interface DocumentedAnnotation {}

    @interface ContainerAnnotation {
        RepeatableAnnotation[] value();
    }

    @Repeatable(ContainerAnnotation.class)
    @interface RepeatableAnnotation {}


    @Target({})
    @interface EmptyTarget {}

    @Target(ElementType.ANNOTATION_TYPE)
    @interface SingleTarget {}

    @Target({
        ElementType.ANNOTATION_TYPE,
        ElementType.CONSTRUCTOR,
        ElementType.FIELD,
        ElementType.LOCAL_VARIABLE,
        ElementType.METHOD,
        ElementType.MODULE,
        ElementType.PACKAGE,
        ElementType.PARAMETER,
        ElementType.RECORD_COMPONENT,
        ElementType.TYPE_PARAMETER,
        ElementType.TYPE_USE
    })
    @interface AllTargets {}


    @Retention(RetentionPolicy.CLASS)
    @interface ClassRetention {}

    @Retention(RetentionPolicy.RUNTIME)
    @interface RuntimeRetention {}

    @Retention(RetentionPolicy.SOURCE)
    @interface SourceRetention {}
}
