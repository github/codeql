import semmle.code.cil.Type
import semmle.code.csharp.commons.QualifiedName

bindingset[kind]
deprecated private string getKind(int kind) {
  if kind = 1 then result = "modreq" else result = "modopt"
}

deprecated query predicate customModifiers(string receiver, string modifier, string kind) {
  exists(Type modType, CustomModifierReceiver cmr, string qualifier, string name, int k |
    receiver = cmr.toString() and
    cil_custom_modifiers(cmr, modType, k) and
    modType.hasFullyQualifiedName(qualifier, name) and
    modifier = getQualifiedName(qualifier, name) and
    kind = getKind(k)
  )
}
