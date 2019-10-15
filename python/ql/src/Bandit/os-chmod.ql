/**
 * @name  Chmod setting a permissive mask
 * @description  Chmod setting a permissive mask on a file
 *         https://bandit.readthedocs.io/en/latest/plugins/b103_set_bad_file_permissions.html
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision hight
 * @id py/bandit/os-chmod
 */

import python

predicate isObjectAttribute(Call c, string objectName, string methodName) {
  c.getFunc().(Attribute).getName().toString() = methodName
  and c.getFunc().(Attribute).getObject().toString() = objectName
}

from Call c
where isObjectAttribute(c, "os", "chmod")
  and (c.getPositionalArg(0).(StrConst).getText() = "/etc/passwd"
  and
    (
        c.getPositionalArg(1).(IntegerLiteral).getText() = "0227"
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0o227"
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "07"
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0o7"
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0664"
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0o664"        
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0777"
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0o777"        
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0770"
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0o770"        
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0o776"
        or c.getPositionalArg(1).(IntegerLiteral).getText() = "0o760"
        or c.getPositionalArg(1).(Attribute).getName() = "S_IRWXU"
    ))
   or  (c.getPositionalArg(0).(StrConst).getText() = "~/.bashrc"
  and
    (
        c.getPositionalArg(1).(IntegerLiteral).getText() = "511"
    ))
   or  (c.getPositionalArg(0).(StrConst).getText() = "/etc/hosts"
  and
    (
        c.getPositionalArg(1).(IntegerLiteral).getText() = "0o777"
    ))        
   or (c.getPositionalArg(1).(IntegerLiteral).getText() = "0x1ff"
          or c.getPositionalArg(1).(IntegerLiteral).getText() = "0o777"
    )
select  c, "Chmod setting a permissive mask on file " + c.getPositionalArg(0).(StrConst).getText()