/** Provides classes and predicates for working with Java Server Faces. */

import default
import semmle.code.java.frameworks.javaee.jsf.JSFAnnotations
import semmle.code.java.frameworks.javaee.jsf.JSFFacesContextXML

/**
 * A method that is visible to faces, if the instance type is visible to faces.
 */
library class FacesVisibleMethod extends Method {
  FacesVisibleMethod() { isPublic() and not isStatic() }
}

/**
 * A Java Server Faces managed bean class, specified in either an XML configuration file, or through
 * annotations on the class itself.
 *
 * A managed bean class will be constructed by JSF. It may be referred to in Java EL expressions,
 * for example, in JSP or facelet files. As such, any public methods may be called by JSF.
 */
class FacesManagedBean extends Class {
  FacesManagedBean() {
    exists(FacesManagedBeanAnnotation beanAnnotation | this = beanAnnotation.getManagedBeanClass()) or
    exists(FacesConfigManagedBeanClass facesConfigBeanClassDecl |
      this = facesConfigBeanClassDecl.getManagedBeanClass()
    )
  }
}

/**
 * A type which may have methods called on it by Java Server Faces.
 *
 * A type is accessible if it is the return type of a method that can be called by JSF, through a
 * Java EL expression. An accessible type may have any public method called by JSF.
 */
class FacesAccessibleType extends RefType {
  FacesAccessibleType() {
    exists(RefType accessibleClass, FacesVisibleMethod accessibleMethod |
      accessibleClass instanceof FacesManagedBean or
      accessibleClass instanceof FacesAccessibleType
    |
      accessibleMethod = accessibleClass.getAMethod() and
      this = accessibleMethod.getReturnType()
    )
  }

  /** Gets a method declared on this type that is visible to JSF. */
  FacesVisibleMethod getAnAccessibleMethod() { result = getAMethod() }
}

/**
 * A Java Server Faces custom component class, specified in either an XML configuration file, or
 * through annotations on the class itself.
 *
 * A custom component can be used in a view - such as a JSP or facelet page. If it is used, then
 * the class will be reflectively constructed, and methods on the base class, `UIComponent`, will
 * be called.
 */
class FacesComponent extends Class {
  FacesComponent() {
    // Must extend UIComponent for it to be a valid component.
    getAnAncestor().hasQualifiedName("javax.faces.component", "UIComponent") and
    (
      // Must be registered using either an annotation
      exists(FacesComponentAnnotation componentAnnotation |
        this = componentAnnotation.getFacesComponentClass()
      )
      or
      // Or in an XML file
      exists(FacesConfigComponentClass componentClassXml |
        this = componentClassXml.getFacesComponentClass()
      )
    )
  }
}
