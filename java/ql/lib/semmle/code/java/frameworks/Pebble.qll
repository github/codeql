/** Definitions related to the Pebble Templating library. */

import java

/** The `PebbleEngine` class of the Pebble Templating Engine. */
class TypePebbleEngine extends Class {
  TypePebbleEngine() { this.hasQualifiedName("com.mitchellbosecke.pebble", "PebbleEngine") }
}

/** The `getTemplate` method of the Pebble Templating Engine. */
class MethodPebbleGetTemplate extends Method {
  MethodPebbleGetTemplate() {
    this.getDeclaringType() instanceof TypePebbleEngine and
    this.hasName(["getTemplate", "getLiteralTemplate"])
  }
}
