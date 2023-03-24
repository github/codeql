/**
 * @name Setting a DACL to NULL in a SECURITY_DESCRIPTOR
 * @description Setting a DACL to NULL in a SECURITY_DESCRIPTOR will result in an unprotected object.
 *              If the DACL that belongs to the security descriptor of an object is set to NULL, a null DACL is created.
 *              A null DACL grants full access to any user who requests it;
 *              normal security checking is not performed with respect to the object.
 * @id cpp/unsafe-dacl-security-descriptor
 * @kind problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @tags security
 *       external/cwe/cwe-732
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * A function call to SetSecurityDescriptorDacl to set the ACL, specified by (2nd argument) bDaclPresent = TRUE
 */
class SetSecurityDescriptorDaclFunctionCall extends FunctionCall {
  SetSecurityDescriptorDaclFunctionCall() {
    this.getTarget().hasGlobalName("SetSecurityDescriptorDacl") and
    this.getArgument(1).getValue().toInt() != 0
  }
}

/**
 * Dataflow that detects a call to SetSecurityDescriptorDacl with a NULL DACL as the pDacl argument
 */
module NullDaclConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof NullValue }

  predicate isSink(DataFlow::Node sink) {
    exists(SetSecurityDescriptorDaclFunctionCall call, VariableAccess val | val = sink.asExpr() |
      val = call.getArgument(2)
    )
  }
}

module NullDaclFlow = DataFlow::Global<NullDaclConfig>;

/**
 * Dataflow that detects a call to SetSecurityDescriptorDacl with a pDacl
 * argument that's _not_ likely to be NULL.
 */
module NonNullDaclConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getType().getUnspecifiedType().(PointerType).getBaseType() =
      any(Type t | t.getName() = "ACL").getUnspecifiedType() and
    (
      // If the value comes from a function whose body we can't see, assume
      // it's not null.
      exists(Call call |
        not exists(call.getTarget().getBlock()) and
        source.asExpr() = call
      )
      or
      // If the value is assigned by reference, assume it's not null. The data
      // flow library cannot currently follow flow from the body of a function to
      // an assignment by reference, so this rule applies whether we see the
      // body or not.
      exists(Call call | call.getAnArgument() = source.asDefiningArgument())
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(SetSecurityDescriptorDaclFunctionCall call | sink.asExpr() = call.getArgument(2))
  }
}

module NonNullDaclFlow = DataFlow::Global<NonNullDaclConfig>;

from SetSecurityDescriptorDaclFunctionCall call, string message
where
  exists(NullValue nullExpr |
    message =
      "Setting a DACL to NULL in a SECURITY_DESCRIPTOR will result in an unprotected object."
  |
    call.getArgument(1).getValue().toInt() != 0 and
    call.getArgument(2) = nullExpr
  )
  or
  exists(VariableAccess var |
    message =
      "Setting a DACL to NULL in a SECURITY_DESCRIPTOR using variable " + var +
        " that is set to NULL will result in an unprotected object."
  |
    var = call.getArgument(2) and
    NullDaclFlow::flowToExpr(var) and
    not NonNullDaclFlow::flowToExpr(var)
  )
select call, message
