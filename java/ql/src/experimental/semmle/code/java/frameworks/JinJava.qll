/** Definitions related to the Jinjava Templating library. */

import java

/** The `Jinjava` class of the Jinjava Templating Engine. */
class TypeJinjava extends Class {
  TypeJinjava() { this.hasQualifiedName("com.hubspot.jinjava", "Jinjava") }
}

/** The `render` method of the Jinjava Templating Engine. */
class MethodJinjavaRender extends Method {
  MethodJinjavaRender() {
    this.getDeclaringType() instanceof TypeJinjava and
    this.hasName("render")
  }
}

/** The `render` method of the Jinjava Templating Engine. */
class MethodJinjavaRenderForResult extends Method {
  MethodJinjavaRenderForResult() {
    this.getDeclaringType() instanceof TypeJinjava and
    this.hasName("renderForResult")
  }
}
