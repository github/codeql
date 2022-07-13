/** DEPRECATED. Import `ServerSideRequestForgeryQuery` instead. */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
import ServerSideRequestForgeryQuery as ServerSideRequestForgeryQuery // ignore-query-import

/** DEPRECATED. Import `ServerSideRequestForgeryQuery` instead. */
deprecated module FullServerSideRequestForgery {
  import ServerSideRequestForgeryCustomizations::ServerSideRequestForgery

  class Configuration = ServerSideRequestForgeryQuery::FullServerSideRequestForgeryConfiguration;
}

/** DEPRECATED. Import `ServerSideRequestForgeryQuery` instead. */
deprecated predicate fullyControlledRequest =
  ServerSideRequestForgeryQuery::fullyControlledRequest/1;

/** DEPRECATED. Import `ServerSideRequestForgeryQuery` instead. */
deprecated module PartialServerSideRequestForgery {
  import ServerSideRequestForgeryCustomizations::ServerSideRequestForgery

  class Configuration = ServerSideRequestForgeryQuery::PartialServerSideRequestForgeryConfiguration;
}
