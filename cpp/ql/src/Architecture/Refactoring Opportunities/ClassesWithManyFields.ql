/**
 * @name Classes with too many fields
 * @description Finds classes with many fields; they could probably be refactored by breaking them down into smaller classes, and using composition.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cpp/class-many-fields
 * @tags maintainability
 *       statistical
 *       non-attributable
 */

import cpp

/**
 * Gets a string describing the kind of a `Class`.
 */
string kindstr(Class c) {
  exists(int kind | usertypes(unresolveElement(c), _, kind) |
    kind = 1 and result = "Struct"
    or
    kind = 2 and result = "Class"
    or
    kind = 6 and result = "Template class"
  )
}

/**
 * Holds if the arguments correspond to information about a `VariableDeclarationEntry`.
 */
predicate vdeInfo(VariableDeclarationEntry vde, Class c, File f, int line) {
  c = vde.getVariable().getDeclaringType() and
  f = vde.getLocation().getFile() and
  line = vde.getLocation().getStartLine()
}

newtype TVariableDeclarationInfo =
  TVariableDeclarationLine(Class c, File f, int line) { vdeInfo(_, c, f, line) }

/**
 * A line that contains one or more `VariableDeclarationEntry`s (in the same class).
 */
class VariableDeclarationLine extends TVariableDeclarationInfo {
  Class c;
  File f;
  int line;

  VariableDeclarationLine() {
    vdeInfo(_, c, f, line) and
    this = TVariableDeclarationLine(c, f, line)
  }

  /**
   * Gets the class associated with this `VariableDeclarationLine`.
   */
  Class getClass() { result = c }

  /**
   * Gets the line of this `VariableDeclarationLine`.
   */
  int getLine() { result = line }

  /**
   * Gets a `VariableDeclarationEntry` on this line.
   */
  VariableDeclarationEntry getAVDE() { vdeInfo(result, c, f, line) }

  /**
   * Gets the start column of the first `VariableDeclarationEntry` on this line.
   */
  int getStartColumn() { result = min(this.getAVDE().getLocation().getStartColumn()) }

  /**
   * Gets the end column of the last `VariableDeclarationEntry` on this line.
   */
  int getEndColumn() { result = max(this.getAVDE().getLocation().getEndColumn()) }

  /**
   * Gets the rank of this `VariableDeclarationLine` in its file and class
   * (that is, the first is 0, the second is 1 and so on).
   */
  private int getRank() {
    line =
      rank[result](VariableDeclarationLine vdl, int l | vdl = TVariableDeclarationLine(c, f, l) | l)
  }

  /**
   * Gets the `VariableDeclarationLine` following this one, if any.
   */
  VariableDeclarationLine getNext() {
    result = TVariableDeclarationLine(c, f, _) and
    result.getRank() = this.getRank() + 1
  }

  /**
   * Gets the `VariableDeclarationLine` following this one, if it is nearby.
   */
  VariableDeclarationLine getProximateNext() {
    result = this.getNext() and
    result.getLine() <= this.getLine() + 3
  }

  string toString() { result = "VariableDeclarationLine" }
}

/**
 * A group of `VariableDeclarationEntry`s in the same class that are approximately
 * contiguous.
 */
class VariableDeclarationGroup extends VariableDeclarationLine {
  VariableDeclarationLine end;

  VariableDeclarationGroup() {
    // there is no `VariableDeclarationLine` within three lines previously
    not any(VariableDeclarationLine prev).getProximateNext() = this and
    // `end` is the last transitively proximate line
    end = this.getProximateNext*() and
    not exists(end.getProximateNext())
  }

  predicate hasLocationInfo(string path, int startline, int startcol, int endline, int endcol) {
    path = f.getAbsolutePath() and
    startline = this.getLine() and
    startcol = this.getStartColumn() and
    endline = end.getLine() and
    endcol = end.getEndColumn()
  }

  /**
   * Gets the number of uniquely named `VariableDeclarationEntry`s in this group.
   */
  int getCount() {
    result =
      count(VariableDeclarationLine l |
        l = this.getProximateNext*()
      |
        l.getAVDE().getVariable().getName()
      )
  }

  override string toString() {
    this.getCount() = 1 and
    result = "declaration of " + this.getAVDE().getVariable().getName()
    or
    this.getCount() > 1 and
    result = "group of " + this.getCount() + " fields here"
  }
}

class ExtClass extends Class {
  predicate hasOneVariableGroup() {
    strictcount(VariableDeclarationGroup vdg | vdg.getClass() = this) = 1
  }

  predicate hasLocationInfo(string path, int startline, int startcol, int endline, int endcol) {
    if this.hasOneVariableGroup()
    then
      exists(VariableDeclarationGroup vdg | vdg.getClass() = this |
        vdg.hasLocationInfo(path, startline, startcol, endline, endcol)
      )
    else this.getLocation().hasLocationInfo(path, startline, startcol, endline, endcol)
  }
}

from ExtClass c, int n, VariableDeclarationGroup vdg, string suffix
where
  n =
    strictcount(string fieldName |
      exists(Field f |
        f.getDeclaringType() = c and
        fieldName = f.getName() and
        // IBOutlet's are a way of building GUIs
        // automatically out of ObjC properties.
        // We don't want to count those for the
        // purposes of this query.
        not f.getType().getAnAttribute().hasName("iboutlet")
      )
    ) and
  n > 15 and
  not c.isConstructedFrom(_) and
  c = vdg.getClass() and
  if c.hasOneVariableGroup() then suffix = "" else suffix = " - see $@"
select c,
  kindstr(c) + " " + c.getName() + " has " + n +
    " fields; we suggest refactoring to 15 fields or fewer" + suffix + ".", vdg, vdg.toString()
