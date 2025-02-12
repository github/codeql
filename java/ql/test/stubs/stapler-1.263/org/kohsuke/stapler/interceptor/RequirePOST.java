// Generated automatically from org.kohsuke.stapler.interceptor.RequirePOST for testing purposes

package org.kohsuke.stapler.interceptor;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.interceptor.Interceptor;
import org.kohsuke.stapler.interceptor.InterceptorAnnotation;
import org.kohsuke.stapler.interceptor.Stage;

@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.METHOD,java.lang.annotation.ElementType.FIELD})
public @interface RequirePOST
{
    static public class Processor extends Interceptor
    {
        public Object invoke(StaplerRequest p0, StaplerResponse p1, Object p2, Object[] p3){ return null; }
        public Processor(){}
    }
}
