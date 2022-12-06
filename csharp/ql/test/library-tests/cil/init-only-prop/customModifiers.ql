import semmle.code.cil.Type
import semmle.code.csharp.commons.QualifiedName

bindingset[kind]
private string getKind(int kind) { if kind = 1 then result = "modreq" else result = "modopt" }

from string receiver, string modifier, int kind
where
  exists(Type modType, CustomModifierReceiver cmr, string namespace, string name |
    receiver = cmr.toString() and
    cil_custom_modifiers(cmr, modType, kind) and
    modType.hasQualifiedName(namespace, name) and
    modifier = getQualifiedName(namespace, name)
  )
select receiver, modifier, getKind(kind)
