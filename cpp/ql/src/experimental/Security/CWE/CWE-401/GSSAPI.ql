/**
 * @name Memory leak on resources allocated by GSSAPI functions.
 * @description A number of GSSAPI functions allocate resources that should be freed by the caller when no longer needed.
 * @kind problem
 * @id cpp/gssapi-memory-leak
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       experimental
 *       external/cwe/cwe-401
 */

import cpp
import semmle.code.cpp.controlflow.StackVariableReachability
import semmle.code.cpp.controlflow.Guards

abstract class GssResource extends Type {
  abstract string getDeallocationFunctionName();
}

abstract class GssResourcePointer extends GssResource, PointerType { }

abstract class GssResourceStruct extends GssResource, Struct { }

class GssOidDescStruct extends GssResourcePointer {
  GssOidDescStruct() { this.getBaseType().hasName("gss_OID_desc_struct") }

  override string getDeallocationFunctionName() { result = "gss_release_oid" }
}

class GssOidSetDescStruct extends GssResourcePointer {
  GssOidSetDescStruct() { this.getBaseType().hasName("gss_OID_set_desc_struct") }

  override string getDeallocationFunctionName() { result = "gss_release_oid_set" }
}

class GssBufferDescStruct extends GssResourceStruct {
  GssBufferDescStruct() { this.hasGlobalName("gss_buffer_desc_struct") }

  override string getDeallocationFunctionName() { result = "gss_release_buffer" }
}

class GssNameStruct extends GssResourcePointer {
  GssNameStruct() { this.getBaseType().hasName("gss_name_struct") }

  override string getDeallocationFunctionName() { result = "gss_release_name" }
}

class GssResourceAllocFunctionCall extends FunctionCall {
  int argIndex;
  GssResource resourceType;

  GssResourceAllocFunctionCall() {
    exists(string name |
      this.getTarget().hasGlobalName(name) and
      (
        name = "gss_accept_sec_context" and
        argIndex = 7 and
        resourceType instanceof GssBufferDescStruct
        or
        name = "gss_acquire_cred" and
        argIndex = 6 and
        resourceType instanceof GssOidSetDescStruct
        or
        name = "gss_create_empty_oid_set" and
        argIndex = 1 and
        resourceType instanceof GssOidSetDescStruct
        or
        name = "gss_display_name" and
        argIndex = 2 and
        resourceType instanceof GssBufferDescStruct
        or
        name = "gss_display_status" and
        argIndex = 5 and
        resourceType instanceof GssBufferDescStruct
        or
        name = "gss_export_name" and
        argIndex = 2 and
        resourceType instanceof GssBufferDescStruct
        or
        name = "gss_get_mic" and
        argIndex = 4 and
        resourceType instanceof GssBufferDescStruct
        or
        name = "gss_import_name" and
        argIndex = 3 and
        resourceType instanceof GssNameStruct
        or
        name = "gss_indicate_mechs" and
        argIndex = 1 and
        resourceType instanceof GssOidSetDescStruct
        or
        name = "gss_init_sec_context" and
        argIndex = 10 and
        resourceType instanceof GssBufferDescStruct
        or
        name = "gss_inquire_cred" and
        argIndex = 5 and
        resourceType instanceof GssBufferDescStruct
      )
    )
  }

  int getResourceArgIndex() { result = argIndex }

  Expr getResourceArgExpr() { result = this.getArgument(this.getResourceArgIndex()) }

  GssResource getResourceType() { result = resourceType }
}

class StatusStackVariable extends StackVariable {
  StatusStackVariable() { this.getType().hasName("OM_uint32") }
}

predicate resourceIsAllocated(
  ControlFlowNode def, ControlFlowNode node, StackVariable v, StatusStackVariable status,
  GssResourceAllocFunctionCall allocCall
) {
  allocCall = node and
  allocCall.getResourceArgExpr().(AddressOfExpr).getOperand().(VariableAccess).getTarget() = v and
  exprDefinition(status, def, allocCall)
}

class ResourceWithStatus extends StackVariable {
  StatusStackVariable status;
  GssResource resourceType;

  ResourceWithStatus() {
    resourceIsAllocated(_, _, this, status, _) and resourceType = this.getUnderlyingType()
  }

  StatusStackVariable getStatus() { result = status }

  GssResource getResourceType() { result = resourceType }
}

predicate resourceIsFreed(ControlFlowNode node, ResourceWithStatus resource) {
  // Freed with `gss_release_foo(&resource)`
  exists(FunctionCall call |
    call = node and
    call.getTarget().hasName(resource.getResourceType().getDeallocationFunctionName()) and
    call.getAnArgument().getAChild*().(VariableAccess).getTarget() = resource
  )
  or
  // Freed with `free(resource.value)`
  exists(FunctionCall call, FieldAccess access |
    call = node and
    call.getTarget().hasName("free") and
    access = call.getArgument(0) and
    access.getQualifier() = resource.getAnAccess() and
    access.getTarget().hasName("value")
  )
}

/**
 * 'call' is either a direct call to f, or a possible call to f
 * via a function pointer.
 */
predicate mayCallFunction(Expr call, Function f) {
  call.(FunctionCall).getTarget() = f or
  call.(VariableCall).getVariable().getAnAssignedValue().getAChild*().(FunctionAccess).getTarget() =
    f
}

predicate assignedToFieldOrGlobal(StackVariable v, Expr e) {
  e.(Assignment).getRValue() = v.getAnAccess() and
  not e.(Assignment).getLValue().(VariableAccess).getTarget() instanceof StackVariable
  or
  // resource is a pointer, so passed directly
  exists(Expr midExpr, Function mid, int arg |
    v.getUnderlyingType() instanceof GssResourcePointer and
    e.(FunctionCall).getArgument(arg) = v.getAnAccess() and
    mayCallFunction(e, mid) and
    midExpr.getEnclosingFunction() = mid and
    assignedToFieldOrGlobal(mid.getParameter(arg), midExpr)
  )
  or
  e.(ConstructorFieldInit).getExpr() = v.getAnAccess()
}

ControlFlowNode statusCheckSuccessor(ControlFlowNode node, StatusStackVariable status) {
  node.(AnalysedExpr).getNullSuccessor(status) = result
}

class GssAllocVariableReachabilityWithReassignment extends StackVariableReachabilityWithReassignment {
  GssAllocVariableReachabilityWithReassignment() {
    this = "GssAllocVariableReachabilityWithReassignment"
  }

  override predicate isSourceActual(ControlFlowNode node, StackVariable v) {
    exists(ResourceWithStatus rws |
      rws = v and
      resourceIsAllocated(_, node, rws, rws.getStatus(), _)
    )
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable v) {
    exists(ResourceWithStatus rws |
      rws = v and
      exists(statusCheckSuccessor(node, rws.getStatus()))
      or
      resourceIsFreed(node, rws)
      or
      assignedToFieldOrGlobal(rws, node)
      or
      // node may be used directly in query
      rws.getFunction() = node.(ReturnStmt).getEnclosingFunction()
    )
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) {
    v instanceof ResourceWithStatus and
    definitionBarrier(v, node)
  }
}

/**
 * Holds if the value from allocation `def` is still held in Variable `v` upon entering `node`.
 */
predicate allocatedVariableReaches(StackVariable v, ControlFlowNode def, ControlFlowNode node) {
  exists(GssAllocVariableReachabilityWithReassignment r |
    // reachability
    r.reachesTo(def, _, node, v)
    or
    // accept def node itself
    r.isSource(def, v) and
    node = def
  )
}

class GssAllocReachability extends StackVariableReachabilityExt {
  GssAllocReachability() { this = "GssAllocReachability" }

  override predicate isSource(ControlFlowNode node, StackVariable v) {
    exists(ResourceWithStatus rws |
      rws = v and
      resourceIsAllocated(_, node, rws, rws.getStatus(), _)
    )
  }

  override predicate isSink(ControlFlowNode node, StackVariable v) {
    v.getFunction() = node.(ReturnStmt).getEnclosingFunction()
  }

  predicate isStatusCheck(ControlFlowNode node, ControlFlowNode next, ResourceWithStatus rws) {
    // status = gss_foo(&resource);
    // if (status) {
    //     ...
    // }
    node.(AnalysedExpr).getNonNullSuccessor(rws.getStatus()) = next
  }

  predicate isGssErrorStatusCheck(ControlFlowNode node, ControlFlowNode next, ResourceWithStatus rws) {
    // status = gss_foo(&resource);
    // if (GSS_ERROR(status)) {
    //    ...
    // }
    exists(MacroInvocation macro |
      node.isCondition() and
      macro.getMacroName() = "GSS_ERROR" and
      macro.getAnAffectedElement().(VariableAccess).getTarget() = rws.getStatus() and
      node.getATrueSuccessor() = next
    )
  }

  predicate isValueCheck(ControlFlowNode node, ControlFlowNode next, ResourceWithStatus rws) {
    // status = gss_foo(&resource);
    // if (resource.value) {
    //     ...
    // }
    exists(FieldAccess access |
      node = access and
      node.isCondition() and
      access.getQualifier() = rws.getAnAccess() and
      access.getTarget().hasName("value") and
      node.getAFalseSuccessor() = next
    )
  }

  predicate isLengthCheck(ControlFlowNode node, ControlFlowNode next, ResourceWithStatus rws) {
    // status = gss_foo(&resource);
    // if (resource.length != 0) {
    //     ...
    // }
    exists(NEExpr ne |
      node = ne and
      node.isCondition() and
      ne.getLeftOperand().(FieldAccess).getQualifier() = rws.getAnAccess() and
      ne.getLeftOperand().(FieldAccess).getTarget().hasName("length") and
      ne.getRightOperand().getValue() = "0" and
      node.getAFalseSuccessor() = next
    )
  }

  override predicate isBarrier(
    ControlFlowNode source, ControlFlowNode node, ControlFlowNode next, StackVariable v
  ) {
    exists(ResourceWithStatus rws |
      rws = v and
      isSource(source, v) and
      next = node.getASuccessor() and
      (
        isStatusCheck(node, next, rws)
        or
        isGssErrorStatusCheck(node, next, rws)
        or
        isValueCheck(node, next, rws)
        or
        isLengthCheck(node, next, rws)
        or
        exists(StackVariable v0 | v0 = v |
          node.(AnalysedExpr).getNullSuccessor(v0) = next or
          resourceIsFreed(node, v0) or
          assignedToFieldOrGlobal(v0, node)
        )
      )
    )
  }
}

predicate allocationReaches(ControlFlowNode def, ControlFlowNode node) {
  exists(GssAllocReachability r | r.reaches(def, _, node))
}

from GssResourceAllocFunctionCall def, ReturnStmt ret
where
  allocationReaches(def, ret) and
  not exists(StackVariable v |
    allocatedVariableReaches(v, def, ret) and
    ret.getAChild*() = v.getAnAccess()
  )
select def.getResourceArgExpr(), "This memory allocation may not be released at $@.", ret,
  "this exit point", ret.getLocation().getFile().getBaseName(), ret.getLocation().getStartLine()
