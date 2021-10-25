import java
import semmle.code.java.frameworks.struts.StrutsConventions
import semmle.code.java.frameworks.struts.StrutsXML

/**
 * Gets the custom struts mapper class used for this `refType`, if any.
 */
private string getStrutsMapperClass(RefType refType) {
  result = getRootXMLFile(refType).getConstantValue("struts.mapper.class")
}

/**
 * A Struts 2 Action class.
 */
class Struts2ActionClass extends Class {
  Struts2ActionClass() {
    // If there are no XML files present, then we assume we any class that extends a struts 2
    // action must be reflectively constructed, as we have no better indication.
    not exists(XMLFile xmlFile) and
    this.getAnAncestor().hasQualifiedName("com.opensymphony.xwork2", "Action")
    or
    // If there is a struts.xml file, then any class that is specified as an action is considered
    // to be reflectively constructed.
    exists(StrutsXMLAction strutsAction | this = strutsAction.getActionClass())
    or
    // We have determined that this is an action class due to the conventions plugin.
    this instanceof Struts2ConventionActionClass
  }

  /**
   * Gets the method called when the action is activated.
   */
  Method getActionMethod() {
    this.inherits(result) and
    if
      getStrutsMapperClass(this) = "org.apache.struts2.dispatcher.mapper.Restful2ActionMapper" or
      getStrutsMapperClass(this) = "org.apache.struts2.dispatcher.mapper.RestfulActionMapper"
    then
      // The "Restful" action mapper maps rest APIs to specific methods
      result.hasName("index") or
      result.hasName("create") or
      result.hasName("editNew") or
      result.hasName("view") or
      result.hasName("remove") or
      result.hasName("update")
    else
      if
        getStrutsMapperClass(this) = "org.apache.struts2.rest.RestActionMapper" or
        getStrutsMapperClass(this) = "rest"
      then
        // The "Rest" action mapper is provided with the rest plugin, and maps rest APIs to specific
        // methods based on a "ruby-on-rails" style.
        result.hasName("index") or
        result.hasName("show") or
        result.hasName("edit") or
        result.hasName("editNew") or
        result.hasName("create") or
        result.hasName("update") or
        result.hasName("destroy")
      else
        if exists(getStrutsMapperClass(this))
        then
          // Any method could be live, as this is a custom mapper
          any()
        else (
          // Use the default mapping
          exists(StrutsXMLAction strutsAction |
            this = strutsAction.getActionClass() and
            result = strutsAction.getActionMethod()
          )
          or
          result = this.(Struts2ConventionActionClass).getAnActionMethod()
          or
          // In the fall-back case, use both the "execute" and any annotated methods
          not exists(XMLFile xmlFile) and
          (
            result.hasName("executes") or
            exists(StrutsActionAnnotation actionAnnotation |
              result = actionAnnotation.getActionCallable()
            )
          )
        )
  }

  /**
   * Holds if this action class extends the preparable interface.
   */
  predicate isPreparable() {
    getAnAncestor().hasQualifiedName("com.opensymphony.xwork2", "Preparable")
  }

  /**
   * Gets a prepare method, called before the action method.
   *
   * For a given action method named "foo", the prepare method is named "prepareFoo". Prepare
   * methods only exist if the class `isPreparable()`.
   */
  Method getPrepareMethod() {
    isPreparable() and
    exists(Struts2ActionMethod actionMethod |
      actionMethod = getActionMethod() and
      inherits(result) and
      result
          .hasName("prepare" + actionMethod.getName().charAt(0).toUpperCase() +
              actionMethod.getName().suffix(1))
    )
  }
}

/**
 * A Struts 2 Action method, called on an action class in response to an action.
 */
class Struts2ActionMethod extends Method {
  Struts2ActionMethod() {
    exists(Struts2ActionClass actionClass | this = actionClass.getActionMethod())
  }
}

/**
 * A Struts 2 prepare method, called on an action class in preparation for an action method.
 */
class Struts2PrepareMethod extends Method {
  Struts2PrepareMethod() {
    exists(Struts2ActionClass actionClass | this = actionClass.getPrepareMethod())
  }
}

/**
 * A subclass of the Struts 2 `ActionSupport` class.
 */
class Struts2ActionSupportClass extends Class {
  Struts2ActionSupportClass() {
    this.getASupertype+().hasQualifiedName("com.opensymphony.xwork2", "ActionSupport")
  }

  /**
   * Gets a setter method declared on a subclass of `ActionSupport`.
   */
  SetterMethod getASetterMethod() {
    result.getDeclaringType() = this and
    result.isPublic() and
    exists(string name | result.getField().getName().toLowerCase() = name |
      result.getName().toLowerCase().substring(3, result.getName().length()) = name and
      result.getName().matches("set%")
    )
  }
}
