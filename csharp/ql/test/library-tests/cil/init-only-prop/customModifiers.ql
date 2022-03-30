import semmle.code.cil.Type

bindingset[kind]
private string getKind(int kind) { if kind = 1 then result = "modreq" else result = "modopt" }

from string receiver, string modifier, int kind
where
  exists(Type modType, CustomModifierReceiver cmr |
    receiver = cmr.toString() and
    cil_custom_modifiers(cmr, modType, kind) and
    modType.getQualifiedName() = modifier
  )
select receiver, modifier, getKind(kind)
