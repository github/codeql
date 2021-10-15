/**
 * Provides classes for working with Apache Thrift IDL files.
 * This code is under development and may change without warning.
 */

import external.ExternalArtifact

/** An item in the parse tree of the IDL file */
class ThriftElement extends ExternalData {
  string kind;

  ThriftElement() { this.getDataPath() = "thrift-" + kind }

  string getKind() { result = kind }

  string getId() { result = getField(0) }

  int getIndex() { result = getFieldAsInt(1) }

  ThriftElement getParent() { result.getId() = this.getField(2) }

  string getValue() { result = this.getField(3) }

  ThriftElement getChild(int n) { result.getIndex() = n and result.getParent() = this }

  ThriftElement getAChild() { result = this.getChild(_) }

  override string toString() { result = this.getKind() }

  string getPath() { result = this.getField(4) }

  private int line() { result = this.getFieldAsInt(5) }

  private int column() { result = this.getFieldAsInt(6) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    filepath = this.getPath() and
    startline = this.line() and
    startcolumn = this.column() and
    endline = this.line() and
    endcolumn = this.column() + this.getValue().length() - 1
    or
    exists(ThriftElement first, ThriftElement last |
      first = this.getChild(min(int l | exists(this.getChild(l)))) and
      last = this.getChild(max(int l | exists(this.getChild(l)))) and
      first.hasLocationInfo(filepath, startline, startcolumn, _, _) and
      last.hasLocationInfo(filepath, _, _, endline, endcolumn)
    )
  }

  File getFile() { this.hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }
}

abstract class ThriftNamedElement extends ThriftElement {
  abstract ThriftElement getNameElement();

  final string getName() { result = this.getNameElement().getValue() }

  override string toString() {
    result = this.getKind() + " " + this.getName()
    or
    not exists(this.getName()) and result = this.getKind() + " ???"
  }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(ThriftElement first |
      first = this.getChild(min(int l | exists(this.getChild(l)))) and
      first.hasLocationInfo(filepath, startline, startcolumn, _, _) and
      this.getNameElement().hasLocationInfo(filepath, _, _, endline, endcolumn)
    )
  }
}

class ThriftType extends ThriftNamedElement {
  ThriftType() { kind.matches("%type") }

  override ThriftElement getNameElement() {
    result = this.getChild(0)
    or
    result = this.getChild(0).(ThriftType).getNameElement()
  }

  override string toString() { result = "type " + this.getName() }

  predicate references(ThriftStruct struct) {
    this.getName() = struct.getName() and
    exists(string path |
      this.hasLocationInfo(path, _, _, _, _) and
      struct.hasLocationInfo(path, _, _, _, _)
    )
  }
}

/** A thrift typedef */
class ThriftTypeDef extends ThriftNamedElement {
  ThriftTypeDef() { kind.matches("typedef") }

  override ThriftElement getNameElement() { result = this.getChild(2).getChild(0) }
}

/** A thrift enum declaration */
class ThriftEnum extends ThriftNamedElement {
  ThriftEnum() { kind.matches("enum") }

  override ThriftElement getNameElement() { result = this.getChild(0).getChild(0) }
}

/** A thrift enum field */
class ThriftEnumField extends ThriftNamedElement {
  ThriftEnumField() { kind.matches("enumfield") }

  override ThriftElement getNameElement() { result = this.getChild(0).getChild(0) }
}

/** A thrift service declaration */
class ThriftService extends ThriftNamedElement {
  ThriftService() { kind.matches("service") }

  override ThriftElement getNameElement() { result = this.getChild(0).getChild(0) }

  ThriftFunction getAFunction() { result = this.getChild(_) }

  ThriftFunction getFunction(string name) {
    result.getName() = name and
    result = this.getAFunction()
  }
}

/** A thrift function declaration */
class ThriftFunction extends ThriftNamedElement {
  ThriftFunction() { kind.matches("function") }

  override ThriftElement getNameElement() { result = this.getChild(2).getChild(0) }

  ThriftField getArgument(int n) { result = this.getChild(n + 3) }

  ThriftField getAnArgument() { result = this.getArgument(_) }

  private ThriftThrows getAllThrows() { result = this.getChild(_) }

  ThriftField getAThrows() { result = this.getAllThrows().getAChild() }

  ThriftType getReturnType() { result = this.getChild(1).getChild(0) }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getChild(1).hasLocationInfo(filepath, startline, startcolumn, _, _) and
    this.getChild(2).hasLocationInfo(filepath, _, _, endline, endcolumn)
  }

  ThriftService getService() { result.getAFunction() = this }

  string getQualifiedName() { result = this.getService().getName() + "." + this.getName() }
}

class ThriftField extends ThriftNamedElement {
  ThriftField() { kind.matches("field") }

  override ThriftElement getNameElement() { result = this.getChild(4) }

  ThriftType getType() { result = this.getChild(2) }
}

class ThriftStruct extends ThriftNamedElement {
  ThriftStruct() { kind.matches("struct") }

  override ThriftElement getNameElement() { result = this.getChild(0).getChild(0) }

  ThriftField getMember(int n) { result = this.getChild(n + 1) }

  ThriftField getAMember() { result = this.getMember(_) }
}

class ThriftException extends ThriftNamedElement {
  ThriftException() { kind.matches("exception") }

  override ThriftElement getNameElement() { result = this.getChild(0).getChild(0) }

  ThriftField getMember(int n) { result = this.getChild(n + 1) }

  ThriftField getAMember() { result = this.getMember(_) }
}

class ThriftThrows extends ThriftElement {
  ThriftThrows() { kind.matches("throws") }

  ThriftField getAThrows() { result = this.getChild(_) }
}

/** A parse tree element that holds a primitive value */
class ThriftValue extends ThriftElement {
  ThriftValue() { exists(this.getValue()) }

  override string toString() { result = this.getKind() + " " + this.getValue() }
}
