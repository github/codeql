import cil
import semmle.code.cil.Type

private string elementType(Element e, string toString) {
  toString = e.(Method).getQualifiedName() and result = "method"
  or
  toString = e.(Property).getQualifiedName() and result = "property"
  or
  e =
    any(Parameter p |
      toString = "Parameter " + p.getIndex() + " of " + p.getDeclaringElement().getQualifiedName()
    ) and
  result = "parameter"
  or
  e =
    any(LocalVariable v |
      toString =
        "Local variable " + v.getIndex() + " of method " +
          v.getImplementation().getMethod().getQualifiedName()
    ) and
  result = "local"
  or
  toString = e.(FunctionPointerType).getQualifiedName() and result = "fnptr"
  or
  not e instanceof Method and
  not e instanceof Property and
  not e instanceof Parameter and
  not e instanceof LocalVariable and
  not e instanceof FunctionPointerType and
  result = "other" and
  toString = e.toString()
}

private predicate exclude(string s) {
  s in [
      "Parameter 0 of Interop.libobjc.NSOperatingSystemVersion_objc_msgSend_stret",
      "Parameter 1 of Interop.procfs.TryParseStatusFile",
      "Parameter 1 of Interop.procfs.TryReadFile",
      "Parameter 1 of Interop.procfs.TryReadStatusFile",
      "Parameter 1 of System.CLRConfig.GetBoolValue",
      "Parameter 1 of System.CLRConfig.GetConfigBoolValue",
      "Parameter 1 of System.Runtime.InteropServices.ObjectiveC.ObjectiveCMarshal.CreateReferenceTrackingHandleInternal",
      "Parameter 2 of System.Runtime.InteropServices.ObjectiveC.ObjectiveCMarshal.CreateReferenceTrackingHandleInternal",
      "Parameter 2 of System.Runtime.InteropServices.ObjectiveC.ObjectiveCMarshal.InvokeUnhandledExceptionPropagation",
    ]
}

from Element e, int i, string toString, string type
where
  cil_type_annotation(e, i) and
  type = elementType(e, toString) and
  not exclude(toString) and
  (
    not e instanceof Parameter
    or
    e.(Parameter).getDeclaringElement().(Method).getDeclaringType().getQualifiedName() !=
      "System.Environment" // There are OS specific methods in this class
  )
select toString, type, i
