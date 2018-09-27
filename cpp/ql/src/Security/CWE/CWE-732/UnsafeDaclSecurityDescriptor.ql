/**
 * @name Setting a DACL to NULL in a SECURITY_DESCRIPTOR
 * @description Setting a DACL to NULL in a SECURITY_DESCRIPTOR will result in an unprotected object.
 *              If the DACL that belongs to the security descriptor of an object is set to NULL, a null DACL is created. 
 *              A null DACL grants full access to any user who requests it;
 *              normal security checking is not performed with respect to the object.
 * @id cpp/unsafe-dacl-security-descriptor
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-732
 *       external/microsoft/C6248
 */
import cpp
import semmle.code.cpp.dataflow.DataFlow

/**
 * A function call to SetSecurityDescriptorDacl to set the ACL, specified by (2nd argument) bDaclPresent = TRUE
 */
class SetSecurityDescriptorDaclFunctionCall extends FunctionCall {
  SetSecurityDescriptorDaclFunctionCall() {
    this.getTarget().hasGlobalName("SetSecurityDescriptorDacl")
    and this.getArgument(1).getValue().toInt() != 0
  }
}
 
/**
 * Dataflow that detects a call to SetSecurityDescriptorDacl with a NULL DACL as the pDacl argument
 */
class SetSecurityDescriptorDaclFunctionConfiguration extends DataFlow::Configuration {
  SetSecurityDescriptorDaclFunctionConfiguration() {
    this = "SetSecurityDescriptorDaclFunctionConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists( 
      NullValue nullExpr |
      source.asExpr() = nullExpr 
    )
  }
 
  override predicate isSink(DataFlow::Node sink) {
    exists( 
      SetSecurityDescriptorDaclFunctionCall call, VariableAccess val |
      val = sink.asExpr() |
      val = call.getArgument(2) 
    )
  }
}

from SetSecurityDescriptorDaclFunctionCall call, string message
where exists
  ( 
    NullValue nullExpr |
    message = "Setting a DACL to NULL in a SECURITY_DESCRIPTOR will result in an unprotected object." |
    call.getArgument(1).getValue().toInt() != 0
    and call.getArgument(2) = nullExpr
  ) or exists
  ( 
    Expr constassign, VariableAccess var, 
    SetSecurityDescriptorDaclFunctionConfiguration config |
    message = "Setting a DACL to NULL in a SECURITY_DESCRIPTOR using variable " + var + " that is set to NULL will result in an unprotected object." |
    var = call.getArgument(2)
    and config.hasFlow(DataFlow::exprNode(constassign), DataFlow::exprNode(var))
  )
select call, message