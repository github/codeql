/**
 * @name Password in config file
 * @description Finds passwords in config files.
 * @kind problem
 * @problem.severity warning
 * @id py/password-in-config-file
 * @tags security
 *       external/cwe/cwe-13
 *       external/cwe/cwe-256
 *       external/cwe/cwe-313
 */

import python

class ConfigFile extends File {
  ConfigFile() {
    this.getBaseName().toString().regexpMatch(".*config.*") or
    this.getBaseName().toString().regexpMatch(".*cfg.*")
  }
}

class PasswordVariable extends Variable {
  PasswordVariable() {
    this.toString().toLowerCase().regexpMatch(".*password.*") or
    this.toString().toLowerCase().matches("%.*pwd.*%") or
    this.toString().toLowerCase().matches("%.*passwd.*%")
  }
}

from File f, Variable v, Location l
where
  f instanceof ConfigFile and
  v.getAnAccess().getLocation() = l and
  (
    v.getScope().getLocation().getFile() = f and
    v instanceof PasswordVariable
  )
select l, "Avoid plaintext passwords in config files."
