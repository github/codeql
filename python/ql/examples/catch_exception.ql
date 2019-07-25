/**
 * @name Handle exception of given class
 * @description Finds places where we handle MyExceptionClass exceptions
 * @tags catch
 *       try
 *       exception
 */
 
import python

from ExceptStmt ex, ClassObject cls
where 
    cls.getName() = "MyExceptionClass" and
    ex.getType().refersTo(cls)
select ex
