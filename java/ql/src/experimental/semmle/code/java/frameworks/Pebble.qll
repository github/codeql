/* Definitions related to the Pebble Tempalting library. */
import semmle.code.java.Type

/** Models `PebbleEngine` class of Pebble Templating Engine. */
class TypePebbleEngine extends Class {
  TypePebbleEngine() { hasQualifiedName("com.mitchellbosecke.pebble", "PebbleEngine") }
}

/** Models `getTemplate` method of Pebble Templating Engine. */
class MethodPebbleGetTemplate extends Method {
  MethodPebbleGetTemplate() {
    getDeclaringType() instanceof TypePebbleEngine and
    hasName("getTemplate")
  }
}
