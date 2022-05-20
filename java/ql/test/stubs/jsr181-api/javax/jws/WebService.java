package javax.jws;

import java.lang.annotation.Target;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.ElementType;

/**
 * Marks a Java class as implementing a Web Service, or a Java interface as defining a Web Service interface.
 *
 * @author Copyright (c) 2004 by BEA Systems, Inc. All Rights Reserved.
 *
 * @since 1.6
 */
@Retention(value = RetentionPolicy.RUNTIME)
@Target(value = {ElementType.TYPE})
public @interface WebService {

    /**
     * The name of the Web Service.
     * <p>
     * Used as the name of the wsdl:portType when mapped to WSDL 1.1.
     *
     * @specdefault The simple name of the Java class or interface.
     */
    String name() default "";

    /**
     * If the @WebService.targetNamespace annotation is on a service endpoint interface, the targetNamespace is used
     * for the namespace for the wsdl:portType (and associated XML elements).
     * <p>
     * If the @WebService.targetNamespace annotation is on a service implementation bean that does NOT reference a
     * service endpoint interface (through the endpointInterface attribute), the targetNamespace is used for both the
     * wsdl:portType and the wsdl:service (and associated XML elements).
     * <p>
     * If the @WebService.targetNamespace annotation is on a service implementation bean that does reference a service
     * endpoint interface (through the endpointInterface attribute), the targetNamespace is used for only the
     * wsdl:service (and associated XML elements).
     *
     * @specdefault Implementation-defined, as described in JAX-WS 2.0 [5], section 3.2.
     */
    String targetNamespace() default "";

    /**
     * The service name of the Web Service.
     * <p>
     * Used as the name of the wsdl:service when mapped to WSDL 1.1.
     * <p>
     * <i>This member-value is not allowed on endpoint interfaces.</i>
     *
     * @specdefault The simple name of the Java class + Service".
     */
    String serviceName() default "";

    /**
     * The port name of the Web Service.
     * <p>
     * Used as the name of the wsdl:port when mapped to WSDL 1.1.
     * <p>
     * <i>This member-value is not allowed on endpoint interfaces.</i>
     *
     * @specdefault {@code @WebService.name}+Port.
     *
     * @since 2.0
     */
    String portName() default "";

    /**
     * The location of a pre-defined WSDL describing the service.
     * <p>
     * The wsdlLocation is a URL (relative or absolute) that refers to a pre-existing WSDL file.  The presence of a
     * wsdlLocation value indicates that the service implementation bean is implementing a pre-defined WSDL contract.
     * The JSR-181 tool MUST provide feedback if the service implementation bean is inconsistent with the portType and
     * bindings declared in this WSDL. Note that a single WSDL file might contain multiple portTypes and multiple
     * bindings.  The annotations on the service implementation bean determine the specific portType and bindings that
     * correspond to the Web Service.
     */
    String wsdlLocation() default "";

    /**
     * The complete name of the service endpoint interface defining the service's abstract Web Service contract.
     * <p>
     * This annotation allows the developer to separate the interface contract from the implementation.  If this
     * annotation is present, the service endpoint interface is used to determine the abstract WSDL contract (portType
     * and bindings). The service endpoint interface MAY include JSR-181 annotations to customize the mapping from
     * Java to WSDL.
     * <br>
     * The service implementation bean MAY implement the service endpoint interface, but is not REQUIRED to do so.
     * <br>
     * If this member-value is not present, the Web Service contract is generated from annotations on the service
     * implementation bean.  If a service endpoint interface is required by the target environment, it will be
     * generated into an implementation-defined package with an implementation- defined name
     * <p>
     * <i>This member-value is not allowed on endpoint interfaces.</i>
     */
    String endpointInterface() default "";
};
