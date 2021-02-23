/**
 * @name Binding a socket to all network interfaces
 * @description Binding a socket to all interfaces opens it up to traffic from any IPv4 address
 * and is therefore associated with security risks.
 * @kind problem
 * @tags security
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/bind-socket-all-network-interfaces
 */

import python

Value aSocket() { result.getClass() = Value::named("socket.socket") }

CallNode socketBindCall() {
  result = aSocket().attr("bind").(CallableValue).getACall() and major_version() = 3
  or
  result.getFunction().(AttrNode).getObject("bind").pointsTo(aSocket()) and
  major_version() = 2
}

string allInterfaces() { result = "0.0.0.0" or result = "" }

Value getTextValue(string address) {
  result = Value::forUnicode(address) and major_version() = 3
  or
  result = Value::forString(address) and major_version() = 2
}

from CallNode call, TupleValue args, string address
where
  call = socketBindCall() and
  call.getArg(0).pointsTo(args) and
  args.getItem(0) = getTextValue(address) and
  address = allInterfaces()
select call.getNode(), "'" + address + "' binds a socket to all interfaces."
