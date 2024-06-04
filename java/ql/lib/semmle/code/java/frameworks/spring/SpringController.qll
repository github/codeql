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
    this.hasQualifiedName("org.springframework.stereotype", "Controller")
    or
    // `@Controller` can be used as a meta-annotation on other annotation types.
    this.getAnAnnotation().getType() instanceof SpringControllerAnnotation
  }
}

/**
 * An annotation type that identifies Spring rest controllers.
 *
 * Rest controllers are the same as controllers, but imply the `@ResponseBody` annotation.
 */
class SpringRestControllerAnnotation extends SpringControllerAnnotation {
  SpringRestControllerAnnotation() { this.hasName("RestController") }
}

/**
 * A class annotated, directly or indirectly, as a Spring `Controller`.
 */
class SpringController extends Class {
  SpringController() { this.getAnAnnotation().getType() instanceof SpringControllerAnnotation }
}

/**
 * A class annotated, directly or indirectly, as a Spring `RestController`.
 */
class SpringRestController extends SpringController {
  SpringRestController() {
    this.getAnAnnotation().getType() instanceof SpringRestControllerAnnotation
  }
}

/**
 * A method on a Spring controller which is accessed by the Spring MVC framework.
 */
abstract class SpringControllerMethod extends Method {
  SpringControllerMethod() { this.getDeclaringType() instanceof SpringController }
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
    this.hasQualifiedName("org.springframework.web.bind.annotation", "RequestMapping")
    or
    // `@RequestMapping` can be used as a meta-annotation on other annotation types, e.g. GetMapping, PostMapping etc.
    this.getAnAnnotation().getType() instanceof SpringRequestMappingAnnotationType
  }
}

/**
 * An `AnnotationType` that is used to indicate a `ResponseBody`.
 */
class SpringResponseBodyAnnotationType extends AnnotationType {
  SpringResponseBodyAnnotationType() {
    // `@ResponseBody` used directly as an annotation.
    this.hasQualifiedName("org.springframework.web.bind.annotation", "ResponseBody")
  }
}

private class SpringRequestMappingAnnotation extends Annotation {
  SpringRequestMappingAnnotation() { this.getType() instanceof SpringRequestMappingAnnotationType }
}

private Expr getProducesExpr(RefType rt) {
  result = rt.getAnAnnotation().(SpringRequestMappingAnnotation).getValue("produces")
  or
  rt.getAnAnnotation().(SpringRequestMappingAnnotation).getValue("produces").(ArrayInit).getSize() =
    0 and
  result = getProducesExpr(rt.getASupertype())
}

/**
 * A method on a Spring controller that is executed in response to a web request.
 */
class SpringRequestMappingMethod extends SpringControllerMethod {
  SpringRequestMappingAnnotation requestMappingAnnotation;

  SpringRequestMappingMethod() {
    // Any method that declares the @RequestMapping annotation, or overrides a method that declares
    // the annotation. We have to do this explicit check because the @RequestMapping annotation is
    // not declared with @Inherited.
    exists(Method superMethod |
      this.overrides*(superMethod) and
      requestMappingAnnotation = superMethod.getAnAnnotation()
    )
  }

  /** Gets a request mapping parameter. */
  SpringRequestMappingParameter getARequestParameter() { result = this.getAParameter() }

  /** Gets the "produces" @RequestMapping annotation value, if present. If an array is specified, gets the array. */
  Expr getProducesExpr() {
    result = requestMappingAnnotation.getValue("produces")
    or
    requestMappingAnnotation.getValue("produces").(ArrayInit).getSize() = 0 and
    result = getProducesExpr(this.getDeclaringType())
  }

  /** Gets a "produces" @RequestMapping annotation value. If an array is specified, gets a member of the array. */
  Expr getAProducesExpr() {
    result = this.getProducesExpr() and not result instanceof ArrayInit
    or
    result = this.getProducesExpr().(ArrayInit).getAnInit()
  }

  /** Gets the "produces" @RequestMapping annotation value, if present and a string constant. */
  string getProduces() {
    result = this.getProducesExpr().(CompileTimeConstantExpr).getStringValue()
  }

  /** Gets the "value" @RequestMapping annotation value, if present. */
  string getValue() { result = requestMappingAnnotation.getStringValue("value") }

  /** Holds if this is considered an `@ResponseBody` method. */
  predicate isResponseBody() {
    this.getAnAnnotation().getType() instanceof SpringResponseBodyAnnotationType or
    this.getDeclaringType().getAnAnnotation().getType() instanceof SpringResponseBodyAnnotationType or
    this.getDeclaringType() instanceof SpringRestController
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
    this.getType().hasQualifiedName("org.springframework.web.bind.annotation", "ModelAttribute")
  }
}

/** A parameter of a `SpringRequestMappingMethod`. */
class SpringRequestMappingParameter extends Parameter {
  SpringRequestMappingParameter() { this.getCallable() instanceof SpringRequestMappingMethod }

  /** Holds if the parameter should not be consider a direct source of taint. */
  predicate isNotDirectlyTaintedInput() {
    this.getType().(RefType).getAnAncestor() instanceof SpringWebRequest or
    this.getType().(RefType).getAnAncestor() instanceof SpringNativeWebRequest or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("javax.servlet", "ServletRequest") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("javax.servlet", "ServletResponse") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("javax.servlet.http", "HttpSession") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("javax.servlet.http", "PushBuilder") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.security", "Principal") or
    this.getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.http", "HttpMethod") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.util", "Locale") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.util", "TimeZone") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.time", "ZoneId") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.io", "OutputStream") or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.io", "Writer") or
    this.getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.web.servlet.mvc.support", "RedirectAttributes") or
    // Also covers BindingResult. Note, you can access the field value through this interface, which should be considered tainted
    this.getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.validation", "Errors") or
    this.getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.web.bind.support", "SessionStatus") or
    this.getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.web.util", "UriComponentsBuilder") or
    this.getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("org.springframework.data.domain", "Pageable") or
    this instanceof SpringModel
  }

  private predicate isExplicitlyTaintedInput() {
    // InputStream or Reader parameters allow access to the body of a request
    this.getType().(RefType).getAnAncestor() instanceof TypeInputStream or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.io", "Reader") or
    // The SpringServletInputAnnotations allow access to the URI, request parameters, cookie values and the body of the request
    this.getAnAnnotation() instanceof SpringServletInputAnnotation or
    // HttpEntity is like @RequestBody, but with a wrapper including the headers
    // TODO model unwrapping aspects
    this.getType().(RefType).getASourceSupertype*() instanceof SpringHttpEntity or
    this.getAnAnnotation()
        .getType()
        .hasQualifiedName("org.springframework.web.bind.annotation", "RequestAttribute") or
    this.getAnAnnotation()
        .getType()
        .hasQualifiedName("org.springframework.web.bind.annotation", "SessionAttribute")
  }

  private predicate isImplicitRequestParam() {
    // Any parameter which is not explicitly handled, is consider to be an `@RequestParam`, if
    // it is a simple bean property
    not this.isNotDirectlyTaintedInput() and
    not this.isExplicitlyTaintedInput() and
    (
      this.getType() instanceof PrimitiveType or
      this.getType() instanceof TypeString
    )
  }

  private predicate isImplicitModelAttribute() {
    // Any parameter which is not explicitly handled, is consider to be an `@ModelAttribute`, if
    // it is not an implicit request param
    not this.isNotDirectlyTaintedInput() and
    not this.isExplicitlyTaintedInput() and
    not this.isImplicitRequestParam()
  }

  /** Holds if this is an explicit or implicit `@ModelAttribute` parameter. */
  predicate isModelAttribute() {
    this.isImplicitModelAttribute() or
    this.getAnAnnotation() instanceof SpringModelAttributeAnnotation
  }

  /** Holds if the input is tainted. */
  predicate isTaintedInput() {
    this.isExplicitlyTaintedInput()
    or
    // Any parameter which is not explicitly identified, is consider to be an `@RequestParam`, if
    // it is a simple bean property) or a @ModelAttribute if not
    not this.isNotDirectlyTaintedInput()
  }
}

/**
 * A parameter to a `SpringRequestMappingMethod` which represents a model that can be populated by
 * the method, which will be used to render the response e.g. as a JSP file.
 */
abstract class SpringModel extends Parameter {
  SpringModel() { this.getCallable() instanceof SpringRequestMappingMethod }

  /**
   * Types for which instances are placed inside the model.
   */
  abstract RefType getATypeInModel();
}

/**
 * A `java.util.Map` can be accepted as the model parameter for a Spring `RequestMapping` method.
 */
class SpringModelPlainMap extends SpringModel {
  SpringModelPlainMap() { this.getType() instanceof MapType }

  override RefType getATypeInModel() {
    exists(MethodCall methodCall |
      methodCall.getQualifier() = this.getAnAccess() and
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
    this.getType().(RefType).hasQualifiedName("org.springframework.ui", "Model") or
    this.getType().(RefType).hasQualifiedName("org.springframework.ui", "ModelMap")
  }

  override RefType getATypeInModel() {
    exists(MethodCall methodCall |
      methodCall.getQualifier() = this.getAnAccess() and
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
