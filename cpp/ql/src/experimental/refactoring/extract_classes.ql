import relevant

/*
    A "class" is an island of globals and functions where all globals and functions are connected
    to each other.

*/

class ExtractedClass extends RelevantGlobalVariable
{
    ExtractedClass()
    {
        any()
    }

    Function getAFunction()
    {
        result = this.getAnAccess().getEnclosingFunction()
    }

    
}

predicate reaches(GlobalVariable v1, GlobalVariable v2)
{
    exists(Function fn | v1.getAnAccess().getEnclosingFunction() = fn and
                        v2.getAnAccess().getEnclosingFunction() = fn)
}

predicate primary(RelevantGlobalVariable v1)
{
    exists(RelevantGlobalVariable v2 | reaches(v1, v2)) and
    not exists(RelevantGlobalVariable v2 | reaches*(v1, v2) | v1.getName() < v2.getName())
}

from RelevantGlobalVariable var
where primary(var)
select var, "This is a primary global variable"
