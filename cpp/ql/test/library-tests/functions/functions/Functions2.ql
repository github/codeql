/**
 * @name Functions2
 * @kind table
 */
import cpp

from Class c, string ctype, MemberFunction f, string ftype
where
	if c instanceof Struct then ctype = "Struct" else ctype = "Class" and
	(
		(f = c.getAConstructor() and ftype = "constructor") or
		(f = c.getDestructor() and ftype = "destructor") or
		(f.getDeclaringType() = c and ftype = "member function")
	)
select c, ctype, f, ftype
