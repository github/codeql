/**
 * @name Hard-coded use of a deprecated security protocol
 * @description Using a deprecated security protocol rather than the system default is risky.
 * @kind problem
 * @problem.severity error
 * @id cpp/microsoft/public/use-of-deprecated-security-protocol
 */

import cpp
import HardCodedSecurityProtocol

from ProtocolConstant constantValue, DataFlow::Node grbitEnabledProtocolsAssignment
where
  GrbitEnabledConstantTace::flow(DataFlow::exprNode(constantValue), grbitEnabledProtocolsAssignment) and
  // If the system default hasn't been specified, and TLS2 has not been specified, then this is a deprecated security protocol
  not constantValue.isSystemDefault() and
  not constantValue.isTLS1_2Only() and
  not constantValue.isTLS1_3Only()
select constantValue,
  "Hard-coded use of deprecated security protocol " + getConstantName(constantValue) +
    " set here $@.", constantValue, getConstantName(constantValue)
