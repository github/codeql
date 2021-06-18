package javax.jws;

import java.lang.annotation.Target;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Customizes a method that is exposed as a Web Service operation.
 * The associated method must be public and its parameters return value,
 * and exceptions must follow the rules defined in JAX-RPC 1.1, section 5.
 *
 *  The method is not required to throw java.rmi.RemoteException.
 *
 * @author Copyright (c) 2004 by BEA Systems, Inc. All Rights Reserved.
 *
 * @since 1.6
 */
@Retention(value = RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
public @interface WebMethod {

    /**
     * Name of the wsdl:operation matching this method.
     *
     * @specdefault Name of the Java method.
     */
    String operationName() default "";

    /**
     * The action for this operation.
     * <p>
     * For SOAP bindings, this determines the value of the soap action.
     */
    String action() default "";

    /**
     * Marks a method to NOT be exposed as a web method.
     * <p>
     * Used to stop an inherited method from being exposed as part of this web service.
     * If this element is specified, other elements MUST NOT be specified for the @WebMethod.
     * <p>
     * <i>This member-value is not allowed on endpoint interfaces.</i>
     *
     * @since 2.0
     */
    boolean exclude() default false;
};
