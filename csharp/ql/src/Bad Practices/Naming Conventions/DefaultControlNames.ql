/**
 * @name Windows controls with generated names
 * @description Replacing the generated names in windows forms with meaningful names
 *              makes it easier for other developers to understand the code.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/forms/default-control-name
 * @tags readability
 *       naming
 */

import csharp

predicate controlName(string prefix) {
  prefix =
    [
      "[Ll]abel", "[Bb]utton", "[Pp]anel", "[Rr]adio[Bb]utton", "[Pp]rop", "[Ss]atus[Ss]trip",
      "[Tt]able[Ll]ayout[Dd]esigner", "[Tt]ext[Bb]ox", "[Tt]ool[Ss]trip", "[Pp]icture[Bb]ox"
    ]
}

predicate usedInHumanWrittenCode(Field f) {
  exists(File file |
    f.getAnAccess().getFile() = file and
    not file.getBaseName().toLowerCase().matches("%.designer.cs")
  )
}

from Field field, ValueOrRefType widget, string prefix
where
  widget.getABaseType*().hasQualifiedName("System.Windows.Forms.Control") and
  field.getType() = widget and
  field.getName().regexpMatch(prefix + "[0-9]+") and
  controlName(prefix) and
  usedInHumanWrittenCode(field)
select field, "Control '" + field.getName() + "' should have a meaningful name."
