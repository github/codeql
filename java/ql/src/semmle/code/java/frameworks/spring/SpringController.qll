import java

/**
 * An annotation type that identifies Spring components.
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
 * A class annotated, directly or indirectly, as a Spring `Controller`.
 */
class SpringController extends Class {
  SpringController() { getAnAnnotation().getType() instanceof SpringControllerAnnotation }
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
      superMethod.hasAnnotation("org.springframework.web.bind.annotation", "ModelAttribute")
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
 * A method on a Spring controller that is executed in response to a web request.
 */
class SpringRequestMappingMethod extends SpringControllerMethod {
  SpringRequestMappingMethod() {
    // Any method that declares the @RequestMapping annotation, or overrides a method that declares
    // the annotation. We have to do this explicit check because the @RequestMapping annotation is
    // not declared with @Inherited.
    exists(Method superMethod |
      this.overrides*(superMethod) and
      superMethod.hasAnnotation("org.springframework.web.bind.annotation", "RequestMapping")
    )
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
  SpringModelPlainMap() { getType().(RefType).hasQualifiedName("java.util", "Map") }

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
