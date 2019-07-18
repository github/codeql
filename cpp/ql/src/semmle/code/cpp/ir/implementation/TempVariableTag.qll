private import semmle.code.cpp.ir.internal.TempVariableTag

class TempVariableTag extends TTempVariableTag {
  string toString() {
    result = getTempVariableTagId(this)
  }
}
