import java
import semmle.code.java.Maps
import SpringWeb
import SpringWebClient

/**
 * An annotation type that identifies Spring controllers.
 */
class SpringControllerAnnotation extends AnnotationType {
  SpringControllerAnnotation() {
    // `@Controller` used directly as an annotation.
    hasQualifiedName("org.springframework.stereotype", "Controller")
    or
    // `@Controller` can be used as a meta-annotation on other annotation types.
    getAnAnnotation().getType() instanceof SpringControllerAnnotation
  }
}

/**
 * An annotation type that identifies Spring rest controllers.
 *
 * Rest controllers are the same as controllers, but imply the `@ResponseBody` annotation.
 */
class SpringRestControllerAnnotation extends SpringControllerAnnotation {
  SpringRestControllerAnnotation() { hasName("RestController") }
}

/**
 * A class annotated, directly or indirectly, as a Spring `Controller`.
 */
class SpringController extends Class {
  SpringController() { getAnAnnotation().getType() instanceof SpringControllerAnnotation }
}

/**
 * A class annotated, directly or indirectly, as a Spring `RestController`.
 */
class SpringRestController extends SpringController {
  SpringRestController() { getAnAnnotation().getType() instanceof SpringRestControllerAnnotation }
}

/**
 * A method on a Spring controller which is accessed by the Spring MVC framework.
 */
abstract class SpringControllerMethod extends Method {
  SpringControllerMethod() { getDeclaringType() instanceof SpringController }
}

/**
 * A method on a Spring controller that builds a "model attribute" that will be returned with the
 * response as part of the model.
 */
class SpringModelAttributeMethod extends SpringControllerMethod {
  SpringModelAttributeMethod() {
    // Any method that declares the @ModelAttribute annotation, or overrides a method that declares
    // the annotation. We have to do this explicit check because the @ModelAttribute annotation is
    // not declared with @Inherited.
    exists(Method superMethod |
      this.overrides*(superMethod) and
      superMethod.getAnAnnotation() instanceof SpringModelAttributeAnnotation
    )
  }
}

/**
 * A method on a Spring controller that configures a binder for this controller.
 */
class SpringInitBinderMethod extends SpringControllerMethod {
  SpringInitBinderMethod() {
    // Any method that declares the @InitBinder annotation, or overrides a method that declares
    // the annotation. We have to do this explicit check because the @InitBinder annotation is
    // not declared with @Inherited.
    exists(Method superMethod |
      this.overrides*(superMethod) and
      superMethod.hasAnnotation("org.springframework.web.bind.annotation", "InitBinder")
    )
  }
}

/**
 * An `AnnotationType` that is used to indicate a `RequestMapping`.
 */
class SpringRequestMappingAnnotationType extends AnnotationType {
  SpringRequestMappingAnnotationType() {
    // `@RequestMapping` used directly as an annotation.
    hasQualifiedName("org.springframework.web.bind.annotation", "RequestMapping")
    or
    // `@RequestMapping` can be used as a meta-annotation on other annotation types, e.g. GetMapping, PostMapping etc.
    getAnAnnotation().getType() instanceof SpringRequestMappingAnnotationType
  }
}

/**
 * An `AnnotationType` that is used to indicate a `ResponseBody`.
 */
class SpringResponseBodyAnnotationType extends AnnotationType {
  SpringResponseBodyAnnotationType() {
    // `@ResponseBody` used directly as an annotation.
    hasQualifiedName("org.springframework.web.bind.annotation", "ResponseBody")
  }
}

/**
 * A method on a Spring controller that is executed in response to a web request.
 */
class SpringRequestMappingMethod extends SpringControllerMethod {
  Annotation requestMappingAnnotation;

  SpringRequestMappingMethod() {
    // Any method that declares the @RequestMapping annotation, or overrides a method that declares
    // the annotation. We have to do this explicit check because the @RequestMapping annotation is
    // not declared with @Inherited.
    exists(Method superMethod |
      this.overrides*(superMethod) and
      requestMappingAnnotation = superMethod.getAnAnnotation() and
      requestMappingAnnotation.getType() instanceof SpringRequestMappingAnnotationType
    )
  }

  /** Gets a request mapping parameter. */
  SpringRequestMappingParameter getARequestParameter() { result = getAParameter() }

  /** Gets the "produces" @RequestMapping annotation value, if present. */
  string getProduces() {
    result =
      requestMappingAnnotation.getValue("produces").(CompileTimeConstantExpr).getStringValue()
  }

  /** Holds if this is considered an `@ResponseBody` method. */
  predicate isResponseBody() {
    getAnAnnotation().getType() instanceof SpringResponseBodyAnnotationType or
    getDeclaringType().getAnAnnotation().getType() instanceof SpringResponseBodyAnnotationType or
    getDeclaringType() instanceof SpringRestController
  }
}

/** A Spring framework annotation indicating remote user input from servlets. */
class SpringServletInputAnnotation extends Annotation {
  SpringServletInputAnnotation() {
    exists(AnnotationType a |
      a = this.getType() and
      a.getPackage().getName() = "org.springframework.web.bind.annotation"
    |
      a.hasName("MatrixVariable") or
      a.hasName("RequestParam") or
      a.hasName("RequestHeader") or
      a.hasName("CookieValue") or
      a.hasName("RequestPart") or
      a.hasName("PathVariable") or
      a.hasName("RequestBody")
    )
  }
}

/** An annotation of the type `org.springframework.web.bind.annotation.ModelAttribute`. */
class SpringModelAttributeAnnotation extends Annotation {
  SpringModelAttributeAnnotation() {
    getType().hasQualifiedName("org.springframework.web.bind.annotation", "ModelAttribute")
  }
}

/** A parameter of a `SpringRequestMappingMethod`. */
class SpringRequestMappingParameter extends Parameter {
  SpringRequestMappingParameter() { getCallable() instanceof SpringRequestMappingMethod }

  /** Holds if the parameter should not be consider a direct source of taint. */
  predicate isNotDirectlyTaintedInput() {
    getType().(RefType).getAnAncestor() instanceof SpringWebRequest or
    getType().(RefType).getAnAncestor() instanceof SpringNativeWebRequest or
    getType().(RefType).getAnAncestor().hasQualifiedName("javax.servlet", "ServletRequest") or
    getType().(RefType).getAnAncestor().hasQualifiedName("javax.servlet", "ServletResponse") or
    getType().(RefType).getAnAncestor().hasQualifiedName("javax.servlet.http", "HttpSession") or
    getType().(RefType).getAnAncestor().hasQualifiedName("javax.servlet.http", "PushBuilder") or
    getType().(RefType).getAnAncestor().hasQualifiedName("java.security", "Principal") or
    getType().(RefType).getAnAncestor().hasQualifiedName("org.springframework.http", "HttpMethod") or
    getType().(RefType).getAnAncestor().hasQualifiedName("java.util", "Locale") or
    getType().(RefType).getAnAncestor().hasQualifiedName("java.util", "TimeZone") or
    getType().(RefType).getAnAncestor().hasQualifiedName("java.time", "ZoneId") or
    getType().(RefType).getAnAncestor().hasQualifiedName("java.io", "OutputStream") or
    getType().(RefType).getAnAncestor().hasQualifiedName("java.io", "Writer") or
    getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.web.servlet.mvc.support", "RedirectAttributes") or
    // Also covers BindingResult. Note, you can access the field value through this interface, which should be considered tainted
    getType().(RefType).getAnAncestor().hasQualifiedName("org.springframework.validation", "Errors") or
    getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.web.bind.support", "SessionStatus") or
    getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.web.util", "UriComponentsBuilder") or
    getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.data.domain", "Pageable") or
    this instanceof SpringModel
  }

  private predicate isExplicitlyTaintedInput() {
    // InputStream or Reader parameters allow access to the body of a request
    getType().(RefType).getAnAncestor().hasQualifiedName("java.io", "InputStream") or
    getType().(RefType).getAnAncestor().hasQualifiedName("java.io", "Reader") or
    // The SpringServletInputAnnotations allow access to the URI, request parameters, cookie values and the body of the request
    this.getAnAnnotation() instanceof SpringServletInputAnnotation or
    // HttpEntity is like @RequestBody, but with a wrapper including the headers
    // TODO model unwrapping aspects
    getType().(RefType).getASourceSupertype*() instanceof SpringHttpEntity or
    this
        .getAnAnnotation()
        .getType()
        .hasQualifiedName("org.springframework.web.bind.annotation", "RequestAttribute") or
    this
        .getAnAnnotation()
        .getType()
        .hasQualifiedName("org.springframework.web.bind.annotation", "SessionAttribute")
  }

  private predicate isImplicitRequestParam() {
    // Any parameter which is not explicitly handled, is consider to be an `@RequestParam`, if
    // it is a simple bean property
    not isNotDirectlyTaintedInput() and
    not isExplicitlyTaintedInput() and
    (
      getType() instanceof PrimitiveType or
      getType() instanceof TypeString
    )
  }

  private predicate isImplicitModelAttribute() {
    // Any parameter which is not explicitly handled, is consider to be an `@ModelAttribute`, if
    // it is not an implicit request param
    not isNotDirectlyTaintedInput() and
    not isExplicitlyTaintedInput() and
    not isImplicitRequestParam()
  }

  /** Holds if this is an explicit or implicit `@ModelAttribute` parameter. */
  predicate isModelAttribute() {
    isImplicitModelAttribute() or
    getAnAnnotation() instanceof SpringModelAttributeAnnotation
  }

  /** Holds if the input is tainted. */
  predicate isTaintedInput() {
    isExplicitlyTaintedInput()
    or
    // Any parameter which is not explicitly identified, is consider to be an `@RequestParam`, if
    // it is a simple bean property) or a @ModelAttribute if not
    not isNotDirectlyTaintedInput()
  }
}

/**
 * A parameter to a `SpringRequestMappingMethod` which represents a model that can be populated by
 * the method, which will be used to render the response e.g. as a JSP file.
 */
abstract class SpringModel extends Parameter {
  SpringModel() { getCallable() instanceof SpringRequestMappingMethod }

  /**
   * Types for which instances are placed inside the model.
   */
  abstract RefType getATypeInModel();
}

/**
 * A `java.util.Map` can be accepted as the model parameter for a Spring `RequestMapping` method.
 */
class SpringModelPlainMap extends SpringModel {
  SpringModelPlainMap() { getType() instanceof MapType }

  override RefType getATypeInModel() {
    exists(MethodAccess methodCall |
      methodCall.getQualifier() = getAnAccess() and
      methodCall.getCallee().hasName("put")
    |
      result = methodCall.getArgument(1).getType()
    )
  }
}

/**
 * A Spring `Model` or `ModelMap` can be accepted as the model parameter for a Spring `RequestMapping`
 * method.
 */
class SpringModelModel extends SpringModel {
  SpringModelModel() {
    getType().(RefType).hasQualifiedName("org.springframework.ui", "Model") or
    getType().(RefType).hasQualifiedName("org.springframework.ui", "ModelMap")
  }

  override RefType getATypeInModel() {
    exists(MethodAccess methodCall |
      methodCall.getQualifier() = getAnAccess() and
      methodCall.getCallee().hasName("addAttribute")
    |
      result = methodCall.getArgument(methodCall.getNumArgument() - 1).getType()
    )
  }
}

/**
 * A `RefType` that is included in a model that is used in a response by the Spring MVC.
 */
class SpringModelResponseType extends RefType {
  SpringModelResponseType() {
    exists(SpringModelAttributeMethod modelAttributeMethod |
      this = modelAttributeMethod.getReturnType()
    ) or
    exists(SpringModel model | usesType(model.getATypeInModel(), this))
  }
}

/** Strips wrapper types. */
private RefType stripType(Type t) {
  result = t or
  result = stripType(t.(Array).getComponentType()) or
  result = stripType(t.(ParameterizedType).getATypeArgument())
}

/**
 * A user data type that may be populated from an HTTP request.
 *
 * This includes types directly referred to as either `@ModelAttribute` or `@RequestBody` parameters,
 * or types that are referred to by those types.
 */
class SpringUntrustedDataType extends RefType {
  SpringUntrustedDataType() {
    exists(SpringRequestMappingParameter p |
      p.isModelAttribute()
      or
      p.getAnAnnotation().(SpringServletInputAnnotation).getType().hasName("RequestBody")
    |
      this.fromSource() and
      this = stripType(p.getType())
    )
    or
    exists(SpringRestTemplateResponseEntityMethod rm |
      this = stripType(rm.getAReference().getType().(ParameterizedType).getTypeArgument(0)) and
      this.fromSource()
    )
    or
    exists(SpringUntrustedDataType mt |
      this = stripType(mt.getAField().getType()) and
      this.fromSource()
    )
  }
}
