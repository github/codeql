private import java
private import semmle.code.java.dataflow.internal.ModelExclusions
private import ModelEditor

/**
 * A class of effectively public callables from source code.
 */
class PublicEndpointFromSource extends Endpoint, ModelApi { }
