/**
 * Contains customizations to the standard library.
 *
 * This module is imported by `python.qll`, so any customizations defined here automatically
 * apply to all queries.
 *
 * Typical examples of customizations include adding new subclasses of abstract classes such as
 * the `RemoteFlowSource::Range` and `AdditionalTaintStep` classes associated with the security
 * queries to model frameworks that are not covered by the standard library.
 */

import python
/* General import that is useful */
// import experimental.dataflow.DataFlow
//
/* for extending `TaintTracking::AdditionalTaintStep` */
// import experimental.dataflow.TaintTracking
//
/* for extending `RemoteFlowSource::Range` */
// import experimental.dataflow.RemoteFlowSources
