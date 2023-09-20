private import java
private import ModelEditor

/**
 * A class of effectively public callables in library code.
 */
class ExternalEndpoint extends Endpoint {
  ExternalEndpoint() { not this.fromSource() }
}
