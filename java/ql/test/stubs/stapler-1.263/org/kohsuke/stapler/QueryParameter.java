// Generated automatically from org.kohsuke.stapler.QueryParameter for testing purposes

package org.kohsuke.stapler;

import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.kohsuke.stapler.AnnotationHandler;
import org.kohsuke.stapler.InjectedParameter;
import org.kohsuke.stapler.StaplerRequest;

@Documented
@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.PARAMETER})
public @interface QueryParameter
{
    String value();
    boolean fixEmpty();
    boolean required();
    static public class HandlerImpl extends AnnotationHandler<QueryParameter>
    {
        public HandlerImpl(){}
        public Object parse(StaplerRequest p0, QueryParameter p1, Class p2, String p3){ return null; }
    }
}
