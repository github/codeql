package org.kohsuke.stapler;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import static java.lang.annotation.RetentionPolicy.RUNTIME;
import static java.lang.annotation.ElementType.ANNOTATION_TYPE;;

@Retention(RUNTIME)
@Target(ANNOTATION_TYPE)
@Documented
public @interface InjectedParameter {
}
