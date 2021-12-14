/**
 * @name Binding a socket to all network interfaces
 * @description Binding a socket to all interfaces opens it up to traffic from any IPv4 address
 * and is therefore associated with security risks.
 * @kind problem
 * @tags security
 *       external/cwe/cwe-200
 * @problem.severity error
 * @security-severity 6.5
 * @sub-severity low
 * @precision high
 * @id py/bind-socket-all-network-interfaces
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

/** Gets a hostname that can be used to bind to all interfaces. */
private string vulnerableHostname() {
  result in [
      // IPv4
      "0.0.0.0", "",
      // IPv6
      "::", "::0"
    ]
}

/** Gets a reference to a hostname that can be used to bind to all interfaces. */
private DataFlow::TypeTrackingNode vulnerableHostnameRef(DataFlow::TypeTracker t, string hostname) {
  t.start() and
  exists(StrConst allInterfacesStrConst | hostname = vulnerableHostname() |
    allInterfacesStrConst.getText() = hostname and
    result.asExpr() = allInterfacesStrConst
  )
  or
  exists(DataFlow::TypeTracker t2 | result = vulnerableHostnameRef(t2, hostname).track(t2, t))
}

/** Gets a reference to a hostname that can be used to bind to all interfaces. */
DataFlow::Node vulnerableHostnameRef(string hostname) {
  vulnerableHostnameRef(DataFlow::TypeTracker::end(), hostname).flowsTo(result)
}

/** Gets a reference to a tuple for which the first element is a hostname that can be used to bind to all interfaces. */
private DataFlow::TypeTrackingNode vulnerableAddressTuple(DataFlow::TypeTracker t, string hostname) {
  t.start() and
  result.asExpr() = any(Tuple tup | tup.getElt(0) = vulnerableHostnameRef(hostname).asExpr())
  or
  exists(DataFlow::TypeTracker t2 | result = vulnerableAddressTuple(t2, hostname).track(t2, t))
}

/** Gets a reference to a tuple for which the first element is a hostname that can be used to bind to all interfaces. */
DataFlow::Node vulnerableAddressTuple(string hostname) {
  vulnerableAddressTuple(DataFlow::TypeTracker::end(), hostname).flowsTo(result)
}

/**
 * Gets an instance of `socket.socket` using _some_ address family.
 *
 * See https://docs.python.org/3/library/socket.html
 */
API::Node socketInstance() { result = API::moduleImport("socket").getMember("socket").getReturn() }

from DataFlow::CallCfgNode bindCall, DataFlow::Node addressArg, string hostname
where
  bindCall = socketInstance().getMember("bind").getACall() and
  addressArg = bindCall.getArg(0) and
  addressArg = vulnerableAddressTuple(hostname)
select bindCall.asExpr(), "'" + hostname + "' binds a socket to all interfaces."
