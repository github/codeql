
import python
import semmle.python.pointsto.MRO

ClassList mro(ClassObject cls) {
    if cls.isNewStyle() then
        result = new_style_mro(cls)
    else
        result = old_style_mro(cls)
}

from ClassObject cls
where not cls.isBuiltin()

select cls.toString(), mro(cls)

