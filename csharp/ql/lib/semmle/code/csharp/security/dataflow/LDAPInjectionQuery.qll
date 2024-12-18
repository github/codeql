/**
 * Provides a taint-tracking configuration for reasoning about unvalidated user input that is used to
 * construct LDAP queries.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.system.DirectoryServices
private import semmle.code.csharp.frameworks.system.directoryservices.Protocols
private import semmle.code.csharp.security.Sanitizers
private import semmle.code.csharp.dataflow.internal.ExternalFlow

/**
 * A data flow source for unvalidated user input that is used to construct LDAP queries.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for unvalidated user input that is used to construct LDAP queries.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for unvalidated user input that is used to construct LDAP queries.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for unvalidated user input that is used to construct LDAP queries.
 */
module LdapInjectionConfig implements DataFlow::ConfigSig {
  /**
   * Holds if `source` is a relevant data flow source.
   */
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  /**
   * Holds if `sink` is a relevant data flow sink.
   */
  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  /**
   * Holds if data flow through `node` is prohibited. This completely removes
   * `node` from the data flow graph.
   */
  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking configuration for unvalidated user input that is used to construct LDAP queries.
 */
module LdapInjection = TaintTracking::Global<LdapInjectionConfig>;

/**
 * DEPRECATED: Use `ThreadModelSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/** A source supported by the current threat model. */
class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

/** LDAP sinks defined through Models as Data. */
private class ExternalLdapExprSink extends Sink {
  ExternalLdapExprSink() { sinkNode(this, "ldap-injection") }
}

/**
 * An argument that sets the `Path` property of a `DirectoryEntry` object that is a sink for LDAP
 * injection.
 *
 * This is either an argument to the constructor, or to the setter for the property.
 */
class DirectoryEntryPathSink extends Sink {
  DirectoryEntryPathSink() {
    exists(ObjectCreation create |
      create.getTarget() = any(SystemDirectoryServicesDirectoryEntryClass d).getAConstructor()
    |
      this.getExpr() = create.getArgumentForName("path")
    )
    or
    exists(Property path |
      path = any(SystemDirectoryServicesDirectoryEntryClass d).getAProperty() and
      path.hasName("Path")
    |
      this.getExpr() = path.getSetter().getACall().getArgument(0)
    )
  }
}

/**
 * A argument that sets the `Filter` property of a `DirectorySearcher` object that is a sink for
 * LDAP injection.
 *
 * This is either an argument to the constructor, or to the setter for the property.
 */
class DirectorySearcherFilterSink extends Sink {
  DirectorySearcherFilterSink() {
    exists(ObjectCreation create |
      create.getTarget() = any(SystemDirectoryServicesDirectorySearcherClass d).getAConstructor()
    |
      this.getExpr() = create.getArgumentForName("filter")
    )
    or
    exists(Property filter |
      filter = any(SystemDirectoryServicesDirectorySearcherClass d).getAProperty() and
      filter.hasName("Filter")
    |
      this.getExpr() = filter.getSetter().getACall().getArgument(0)
    )
  }
}

/**
 * A argument that sets the `Filter` property of a `SearchRequest` object that is a sink for
 * LDAP injection.
 *
 * This is either an argument to the constructor, or to the setter for the property.
 */
class SearchRequestFilterSink extends Sink {
  SearchRequestFilterSink() {
    exists(ObjectCreation create |
      create.getTarget() = any(SystemDirectoryServicesProtocolsSearchRequest d).getAConstructor()
    |
      this.getExpr() = create.getArgumentForName("ldapFilter") or
      this.getExpr() = create.getArgumentForName("filter")
    )
    or
    exists(Property filter |
      filter = any(SystemDirectoryServicesProtocolsSearchRequest d).getAProperty() and
      filter.hasName("Filter")
    |
      this.getExpr() = filter.getSetter().getACall().getArgument(0)
    )
  }
}

/**
 * A call to a method which is named "LDAP*Encode", which is likely to be an LDAP sanitizer.
 *
 * This will match the encoding methods provided by the AntiXSS library.
 */
class LdapEncodeSanitizer extends Sanitizer {
  LdapEncodeSanitizer() {
    this.getExpr().(MethodCall).getTarget().getName().regexpMatch("(?i)LDAP.*Encode.*")
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
