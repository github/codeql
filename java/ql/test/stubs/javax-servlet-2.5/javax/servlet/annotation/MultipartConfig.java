// Generated automatically from javax.servlet.annotation.MultipartConfig for testing purposes

package javax.servlet.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.TYPE})
public @interface MultipartConfig
{
    String location();
    int fileSizeThreshold();
    long maxFileSize();
    long maxRequestSize();
}
