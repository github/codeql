/**
 * Provides classes representing data flow sinks for remote user output.
 */

import java
private import semmle.code.java.security.XSS

/** A data flow sink of remote user output. */
abstract class RemoteFlowSink extends DataFlow::Node { }
