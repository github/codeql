/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses (for internal use only).
 *
 * This copy of the library is exclusively for use by `OnActivityResultSource.qll` and
 * related libraries. Configurations computed using this instance of the library
 * are in scope whenever `java.qll` is imported, and are used to compute among
 * other things `RemoteFlowSource`s.
 */

import java

/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses (for internal use only).
 */
module DataFlowForOnActivityResult {
  import semmle.code.java.dataflow.internal.DataFlowImplForOnActivityResult
}
