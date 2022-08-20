/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses (for internal use only).
 *
 * This copy of the library is exclusively for use by `Serializability.qll` and
 * related libraries. Configurations computed using this instance of the library
 * are in scope whenever `java.qll` is imported, and are used to compute among
 * other things `AdditionalTaintStep`.
 */

import java

/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses (for internal use only).
 */
module DataFlowForSerializability {
  import semmle.code.java.dataflow.internal.DataFlowImplForSerializability
}
