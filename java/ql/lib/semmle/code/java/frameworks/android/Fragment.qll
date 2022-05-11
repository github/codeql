/** Provides classes and predicates to track Android fragments. */

import java

/** The class `android.app.Fragment`. */
class AndroidFragment extends Class {
  AndroidFragment() { this.getAnAncestor().hasQualifiedName("android.app", "Fragment") }
}

/** The method `instantiate` of the class `android.app.Fragment`. */
class FragmentInstantiateMethod extends Method {
  FragmentInstantiateMethod() {
    this.getDeclaringType() instanceof AndroidFragment and
    this.hasName("instantiate")
  }
}
