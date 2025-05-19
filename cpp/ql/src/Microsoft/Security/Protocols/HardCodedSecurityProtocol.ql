/**
 * @name Hard-coded use of a security protocol
 * @description Hard-coding the security protocol used rather than specifying the system default is
 *              risky because the protocol may become deprecated in future.
 * @kind problem
 * @problem.severity warning
 * @id cpp/microsoft/public/hardcoded-security-protocol
 */

import cpp
import HardCodedSecurityProtocol

from ProtocolConstant constantValue, DataFlow::Node grbitEnabledProtocolsAssignment
where
  GrbitEnabledConstantTace::flow(DataFlow::exprNode(constantValue), grbitEnabledProtocolsAssignment) and
  constantValue.isHardcodedProtocol()
select constantValue,
  "Hard-coded use of security protocol " + getConstantName(constantValue) + " set here $@.",
  grbitEnabledProtocolsAssignment, grbitEnabledProtocolsAssignment.toString()
