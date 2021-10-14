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
  prefix = "[Ll]abel" or
  prefix = "[Bb]utton" or
  prefix = "[Pp]anel" or
  prefix = "[Rr]adio[Bb]utton" or
  prefix = "[Pp]rop" or
  prefix = "[Ss]atus[Ss]trip" or
  prefix = "[Tt]able[Ll]ayout[Dd]esigner" or
  prefix = "[Tt]ext[Bb]ox" or
  prefix = "[Tt]ool[Ss]trip" or
  prefix = "[Pp]icture[Bb]ox"
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
