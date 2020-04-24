/* Definitions related to the Jinjava Tempalting library. */
import semmle.code.java.Type

/** Models `Jinjava` class of Jinjava Templating Engine. */
class TypeJinjava extends Class {
  TypeJinjava() { hasQualifiedName("com.hubspot.jinjava", "JinJava") }
}

/** Models `render` method of Jinjava Templating Engine. */
class MethodJinjavaRender extends Method {
  MethodJinjavaRender() {
    getDeclaringType() instanceof TypeJinjava and
    hasName("render")
  }
}

/** Models `render` method of Jinjava Templating Engine. */
class MethodJinjavaRenderForResult extends Method {
  MethodJinjavaRenderForResult() {
    getDeclaringType() instanceof TypeJinjava and
    hasName("renderForResult")
  }
}
