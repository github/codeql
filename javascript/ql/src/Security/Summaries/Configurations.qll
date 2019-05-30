/**
 * Imports the standard library and a selection of taint-tracking configuration classes
 * from the security queries.
 *
 * To enable flow summarization for other queries, import their configuration classes here.
 */

import javascript
import semmle.javascript.security.dataflow.ClientSideUrlRedirect
import semmle.javascript.security.dataflow.CodeInjection
import semmle.javascript.security.dataflow.CommandInjection
import semmle.javascript.security.dataflow.DomBasedXss as DomBasedXss
import semmle.javascript.security.dataflow.NosqlInjection
import semmle.javascript.security.dataflow.ReflectedXss as ReflectedXss
import semmle.javascript.security.dataflow.ServerSideUrlRedirect
import semmle.javascript.security.dataflow.SqlInjection
import semmle.javascript.security.dataflow.StoredXss as StoredXss
import semmle.javascript.security.dataflow.TaintedPath
import semmle.javascript.security.dataflow.UnsafeDeserialization
import semmle.javascript.security.dataflow.XmlBomb
import semmle.javascript.security.dataflow.Xxe
