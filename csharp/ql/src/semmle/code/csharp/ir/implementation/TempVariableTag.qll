import csharp
private import semmle.code.csharp.ir.internal.TempVariableTag

class TempVariableTag extends TTempVariableTag {
  string toString() {
    result = getTempVariableTagId(this)
  }
}
