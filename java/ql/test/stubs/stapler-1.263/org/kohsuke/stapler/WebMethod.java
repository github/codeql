// Generated automatically from org.kohsuke.stapler.WebMethod for testing purposes

package org.kohsuke.stapler;

import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Documented
@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.METHOD})
public @interface WebMethod
{
    String[] name();
}
