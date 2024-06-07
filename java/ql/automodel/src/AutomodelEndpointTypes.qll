/**
 * For internal use only.
 *
 * Defines the set of classes that endpoint scoring models can predict. Endpoint scoring models must
 * only predict classes defined within this file. This file is the source of truth for the integer
 * representation of each of these classes.
 */

/** A class that can be predicted by a classifier. */
abstract class EndpointType extends string {
  /**
   * Holds when the string matches the name of the sink / source type.
   */
  bindingset[this]
  EndpointType() { any() }

  /**
   * Gets the name of the sink/source kind for this endpoint type as used in models-as-data.
   *
   * See https://github.com/github/codeql/blob/44213f0144fdd54bb679ca48d68b28dcf820f7a8/java/ql/lib/semmle/code/java/dataflow/ExternalFlow.qll#LL353C11-L357C31
   * for sink types, and https://github.com/github/codeql/blob/44213f0144fdd54bb679ca48d68b28dcf820f7a8/java/ql/lib/semmle/code/java/dataflow/ExternalFlow.qll#L365
   * for source types.
   */
  final string getKind() { result = this }
}

/** A class for sink types that can be predicted by a classifier. */
abstract class SinkType extends EndpointType {
  bindingset[this]
  SinkType() { any() }
}

/** A sink relevant to the SQL injection query */
class SqlInjectionSinkType extends SinkType {
  SqlInjectionSinkType() { this = "sql-injection" }
}

/** A sink relevant to the tainted path injection query. */
class PathInjectionSinkType extends SinkType {
  PathInjectionSinkType() { this = "path-injection" }
}

/** A sink relevant to the SSRF query. */
class RequestForgerySinkType extends SinkType {
  RequestForgerySinkType() { this = "request-forgery" }
}

/** A sink relevant to the command injection query. */
class CommandInjectionSinkType extends SinkType {
  CommandInjectionSinkType() { this = "command-injection" }
}

/** A sink relevant to file storage. */
class FileContentStoreSinkType extends SinkType {
  FileContentStoreSinkType() { this = "file-content-store" }
}

/** A sink relevant to HTML injection. */
class HtmlInjectionSinkType extends SinkType {
  HtmlInjectionSinkType() { this = "html-injection" }
}

/** A sink relevant to LDAP injection. */
class LdapInjectionSinkType extends SinkType {
  LdapInjectionSinkType() { this = "ldap-injection" }
}

/** A sink relevant to URL redirection. */
class UrlRedirectionSinkType extends SinkType {
  UrlRedirectionSinkType() { this = "url-redirection" }
}

/** A class for source types that can be predicted by a classifier. */
abstract class SourceType extends EndpointType {
  bindingset[this]
  SourceType() { any() }
}

/** A source of remote data. */
class RemoteSourceType extends SourceType {
  RemoteSourceType() { this = "remote" }
}
