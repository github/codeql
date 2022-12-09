import cil
import semmle.code.csharp.commons.QualifiedName
import semmle.code.cil.Type

private string elementType(Element e, string toString) {
  exists(string namespace, string type, string name |
    toString = getQualifiedName(namespace, type, name)
  |
    e.(Method).hasQualifiedName(namespace, type, name) and result = "method"
    or
    e.(Property).hasQualifiedName(namespace, type, name) and result = "property"
  )
  or
  e =
    any(Parameter p |
      exists(string qualifier, string name |
        p.getDeclaringElement().hasQualifiedName(qualifier, name)
      |
        toString = "Parameter " + p.getIndex() + " of " + getQualifiedName(qualifier, name)
      )
    ) and
  result = "parameter"
  or
  e =
    any(LocalVariable v |
      exists(string namespace, string type, string name |
        v.getImplementation().getMethod().hasQualifiedName(namespace, type, name)
      |
        toString =
          "Local variable " + v.getIndex() + " of method " + getQualifiedName(namespace, type, name)
      )
    ) and
  result = "local"
  or
  exists(string qualifier, string name | e.(FunctionPointerType).hasQualifiedName(qualifier, name) |
    toString = getQualifiedName(qualifier, name)
  ) and
  result = "fnptr"
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
    not exists(Type t |
      t = e.(Parameter).getDeclaringElement().(Method).getDeclaringType() and
      t.hasQualifiedName("System", "Environment")
    ) // There are OS specific methods in this class
  )
select toString, type, i
