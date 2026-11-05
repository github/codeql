package io.micronaut.websocket.annotation;

import java.lang.annotation.*;

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
public @interface ServerWebSocket {
    String value() default "/";
}
