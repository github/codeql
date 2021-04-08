import javascript
import testUtilities.ConsistencyChecking
import semmle.javascript.security.dataflow.DomBasedXss as DomXss
import semmle.javascript.security.dataflow.ReflectedXss as ReflectedXss
import semmle.javascript.security.dataflow.StoredXss as StoredXss
import semmle.javascript.security.dataflow.XssThroughDom as ThroughDomXss
import semmle.javascript.security.dataflow.ExceptionXss as ExceptionXss
import semmle.javascript.security.dataflow.UnsafeJQueryPlugin as UnsafeJqueryPlugin
