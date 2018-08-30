import semmle.code.java.security.Validation

from Method method, int arg
where validationMethod(method, arg)
select method, arg
