// Generated automatically from javax.servlet.annotation.WebServlet for testing purposes

package javax.servlet.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import javax.servlet.annotation.WebInitParam;

@Documented
@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.TYPE})
public @interface WebServlet
{
    String description();
    String displayName();
    String largeIcon();
    String name();
    String smallIcon();
    String[] urlPatterns();
    String[] value();
    WebInitParam[] initParams();
    boolean asyncSupported();
    int loadOnStartup();
}
