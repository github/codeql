package javax.xml.bind.annotation.adapters;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import static java.lang.annotation.RetentionPolicy.RUNTIME;
import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.ElementType.PARAMETER;
import static java.lang.annotation.ElementType.PACKAGE;

@Retention(RUNTIME)
@Target({PACKAGE, FIELD, METHOD, TYPE, PARAMETER})
public @interface XmlJavaTypeAdapter {
}
