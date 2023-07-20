/** Provides classes and predicates for working with Java Server Faces annotations. */

import default

/**
 * A Java Server Faces `ManagedBean` annotation on a class.
 */
class FacesManagedBeanAnnotation extends Annotation {
  FacesManagedBeanAnnotation() {
    this.getType().hasQualifiedName("javax.faces.bean", "ManagedBean")
  }

  /**
   * Gets the `Class` of the managed bean.
   */
  Class getManagedBeanClass() { result = this.getAnnotatedElement() }
}

/**
 * A Java Server Faces `FacesComponent` annotation on a class.
 *
 * This registers the class as a new `UIComponent`, that can be used in views (JSP or facelets).
 */
class FacesComponentAnnotation extends Annotation {
  FacesComponentAnnotation() {
    this.getType().hasQualifiedName("javax.faces.component", "FacesComponent")
  }

  /**
   * Gets the `Class` of the FacesComponent, if this annotation is valid.
   */
  Class getFacesComponentClass() { result = this.getAnnotatedElement() }
}
