// Generated automatically from org.kohsuke.stapler.interceptor.InterceptorAnnotation for testing purposes

package org.kohsuke.stapler.interceptor;

import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.kohsuke.stapler.interceptor.Interceptor;
import org.kohsuke.stapler.interceptor.Stage;

@Documented
@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.ANNOTATION_TYPE})
public @interface InterceptorAnnotation
{
    Class<? extends Interceptor> value();
    Stage stage();
}
