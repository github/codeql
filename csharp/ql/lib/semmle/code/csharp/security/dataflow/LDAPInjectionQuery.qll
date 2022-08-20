/**
 * Provides a taint-tracking configuration for reasoning about unvalidated user input that is used to
 * construct LDAP queries.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import semmle.code.csharp.frameworks.system.DirectoryServices
private import semmle.code.csharp.frameworks.system.directoryservices.Protocols
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for unvalidated user input that is used to construct LDAP queries.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for unvalidated user input that is used to construct LDAP queries.
 */
abstract class Sink extends DataFlow::ExprNode { }

/**
 * A sanitizer for unvalidated user input that is used to construct LDAP queries.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for unvalidated user input that is used to construct LDAP queries.
 */
class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "LDAPInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/** A source of remote user input. */
class RemoteSource extends Source {
  RemoteSource() { this instanceof RemoteFlowSource }
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

/** DEPRECATED: Alias for LdapEncodeSanitizer */
deprecated class LDAPEncodeSanitizer = LdapEncodeSanitizer;

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
