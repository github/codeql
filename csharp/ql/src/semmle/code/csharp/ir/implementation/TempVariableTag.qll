private import internal.TempVariableTagInternal
private import Imports::TempVariableTag

class TempVariableTag extends TTempVariableTag {
  string toString() { result = getTempVariableTagId(this) }
}
