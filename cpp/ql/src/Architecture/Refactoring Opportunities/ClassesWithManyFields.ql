/**
 * @name Classes with too many fields
 * @description Finds classes with many fields; they could probably be refactored by breaking them down into smaller classes, and using composition.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/class-many-fields
 * @tags maintainability
 *       statistical
 *       non-attributable
 */
import cpp

/**
 * Gets a string describing the kind of a `Class`.
 */
string kindstr(Class c)
{
  exists(int kind | usertypes(unresolveElement(c), _, kind) |
    (kind = 1 and result = "Struct") or
    (kind = 2 and result = "Class") or
    (kind = 6 and result = "Template class")
  )
}

/**
 * Holds if the arguments correspond to information about a `VariableDeclarationEntry`.
 */
predicate vdeInfo(VariableDeclarationEntry vde, Class c, File f, int line)
{
  c = vde.getVariable().getDeclaringType() and
  f = vde.getLocation().getFile() and
  line = vde.getLocation().getStartLine()
}

/**
 * Holds if `previous` describes a `VariableDeclarationEntry` occurring soon before
 * `vde` (this may have many results).
 */
predicate previousVde(VariableDeclarationEntry previous, VariableDeclarationEntry vde)
{
  exists(Class c, File f, int line | vdeInfo(vde, c, f, line) |
    vdeInfo(previous, c, f, line - 3) or
    vdeInfo(previous, c, f, line - 2) or
    vdeInfo(previous, c, f, line - 1) or
    (vdeInfo(previous, c, f, line) and exists(int prevCol, int vdeCol |
      prevCol = previous.getLocation().getStartColumn() and vdeCol = vde.getLocation().getStartColumn() |
      prevCol < vdeCol or (prevCol = vdeCol and previous.getName() < vde.getName())
    ))
  )
}

/**
 * The first `VariableDeclarationEntry` in a group.
 */
predicate masterVde(VariableDeclarationEntry master, VariableDeclarationEntry vde)
{
  (not previousVde(_, vde) and master = vde) or
  exists(VariableDeclarationEntry previous | previousVde(previous, vde) and masterVde(master, previous))
}

/**
 * A group of `VariableDeclaratinEntry`'s in the same class and in close proximity
 * to each other.
 */
class VariableDeclarationGroup extends ElementBase {
  VariableDeclarationGroup() {
    this instanceof VariableDeclarationEntry and
    not previousVde(_, this)
  }
  Class getClass() {
    vdeInfo(this, result, _, _)
  }

  // pragma[noopt] since otherwise the two locationInfo relations get join-ordered
  // after each other
  pragma[noopt]
  predicate hasLocationInfo(string path, int startline, int startcol, int endline, int endcol) {
    exists(VariableDeclarationEntry last, Location lstart, Location lend |
      masterVde(this, last) and
      this instanceof VariableDeclarationGroup and
      not previousVde(last, _) and
      exists(VariableDeclarationEntry vde | vde=this and vde instanceof VariableDeclarationEntry and vde.getLocation() = lstart) and
      last.getLocation() = lend and
      lstart.hasLocationInfo(path, startline, startcol, _, _) and
      lend.hasLocationInfo(path, _, _, endline, endcol)
    )
  }

  string describeGroup() {
    if previousVde(this, _) then
      result = "group of "
             + strictcount(string name
                         | exists(VariableDeclarationEntry vde
                                | masterVde(this, vde) and
                                  name = vde.getName()))
             + " fields here"
    else
      result = "declaration of " + this.(VariableDeclarationEntry).getVariable().getName()
  }
}

class ExtClass extends Class {
  predicate hasOneVariableGroup() {
    strictcount(VariableDeclarationGroup vdg | vdg.getClass() = this) = 1
  }

  predicate hasLocationInfo(string path, int startline, int startcol, int endline, int endcol) {
    if hasOneVariableGroup() then
      exists(VariableDeclarationGroup vdg | vdg.getClass() = this | vdg.hasLocationInfo(path, startline, startcol, endline, endcol))
    else
      getLocation().hasLocationInfo(path, startline, startcol, endline, endcol)
  }
}

from ExtClass c, int n, VariableDeclarationGroup vdg, string suffix
where n = strictcount(string fieldName
                    | exists(Field f
                           | f.getDeclaringType() = c and
                             fieldName = f.getName() and
                             // IBOutlet's are a way of building GUIs
                             // automatically out of ObjC properties.
                             // We don't want to count those for the
                             // purposes of this query.
                             not (f.getType().getAnAttribute().hasName("iboutlet")))) and
      n > 15 and
      not c.isConstructedFrom(_) and
      c = vdg.getClass() and
      if c.hasOneVariableGroup() then suffix = "" else suffix = " - see $@"
select c, kindstr(c) + " " + c.getName() + " has " + n + " fields; we suggest refactoring to 15 fields or fewer" + suffix + ".",
       vdg, vdg.describeGroup()
