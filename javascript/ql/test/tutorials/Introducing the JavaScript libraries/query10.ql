import javascript

from Function f, GlobalVariable gv
where gv.getAnAccess().getEnclosingFunction() = f and
    not f.getStartBB().isLiveAtEntry(gv, _)
select f, "This function uses " + gv + " like a local variable."
