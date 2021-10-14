/**
 * @name Import of deprecated module
 * @description Import of a deprecated module
 * @kind problem
 * @tags maintainability
 *       external/cwe/cwe-477
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/import-deprecated-module
 */

import python

/**
 * The module `name` was deprecated in Python version `major`.`minor`,
 * and module `instead` should be used instead (or `instead = "no replacement"`)
 */
predicate deprecated_module(string name, string instead, int major, int minor) {
  name = "posixfile" and instead = "fcntl" and major = 1 and minor = 5
  or
  name = "gopherlib" and instead = "no replacement" and major = 2 and minor = 5
  or
  name = "rgbimgmodule" and instead = "no replacement" and major = 2 and minor = 5
  or
  name = "pre" and instead = "re" and major = 1 and minor = 5
  or
  name = "whrandom" and instead = "random" and major = 2 and minor = 1
  or
  name = "rfc822" and instead = "email" and major = 2 and minor = 3
  or
  name = "mimetools" and instead = "email" and major = 2 and minor = 3
  or
  name = "MimeWriter" and instead = "email" and major = 2 and minor = 3
  or
  name = "mimify" and instead = "email" and major = 2 and minor = 3
  or
  name = "rotor" and instead = "no replacement" and major = 2 and minor = 4
  or
  name = "statcache" and instead = "no replacement" and major = 2 and minor = 2
  or
  name = "mpz" and instead = "a third party" and major = 2 and minor = 2
  or
  name = "xreadlines" and instead = "no replacement" and major = 2 and minor = 3
  or
  name = "multifile" and instead = "email" and major = 2 and minor = 5
  or
  name = "sets" and instead = "builtins" and major = 2 and minor = 6
  or
  name = "buildtools" and instead = "no replacement" and major = 2 and minor = 3
  or
  name = "cfmfile" and instead = "no replacement" and major = 2 and minor = 4
  or
  name = "macfs" and instead = "no replacement" and major = 2 and minor = 3
  or
  name = "md5" and instead = "hashlib" and major = 2 and minor = 5
  or
  name = "sha" and instead = "hashlib" and major = 2 and minor = 5
}

string deprecation_message(string mod) {
  exists(int major, int minor | deprecated_module(mod, _, major, minor) |
    result =
      "The " + mod + " module was deprecated in version " + major.toString() + "." +
        minor.toString() + "."
  )
}

string replacement_message(string mod) {
  exists(string instead | deprecated_module(mod, instead, _, _) |
    result = " Use " + instead + " module instead." and not instead = "no replacement"
    or
    result = "" and instead = "no replacement"
  )
}

from ImportExpr imp, string name, string instead
where
  name = imp.getName() and
  deprecated_module(name, instead, _, _) and
  not exists(Try try, ExceptStmt except | except = try.getAHandler() |
    except.getType().pointsTo(ClassValue::importError()) and
    except.containsInScope(imp)
  )
select imp, deprecation_message(name) + replacement_message(name)
