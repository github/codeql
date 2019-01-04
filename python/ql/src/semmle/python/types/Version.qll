import python
import semmle.python.GuardedControlFlow
private import semmle.python.pointsto.PointsTo

/** A Version of the Python interpreter.
 * Currently only 2.7 or 3.x but may include different sets of versions in the future. */
class Version extends int {

    Version() {
        this = 2 or this = 3
    }

    /** Holds if this version (or set of versions) includes the version `major`.`minor` */
    predicate includes(int major, int minor) {
        this = 2 and major = 2 and minor = 7
        or
        this = 3 and major = 3 and minor in [4..7]
    }

}

Object theSysVersionInfoTuple() {
    py_cmembers_versioned(theSysModuleObject(), "version_info", result, major_version().toString())
}

Object theSysHexVersionNumber() {
    py_cmembers_versioned(theSysModuleObject(), "hexversion", result, major_version().toString())
}

Object theSysVersionString() {
    py_cmembers_versioned(theSysModuleObject(), "version", result, major_version().toString())
}


string reversed(Cmpop op) {
    op instanceof Lt and result = ">"
    or
    op instanceof Gt and result = "<"
    or
    op instanceof GtE and result = "<="
    or
    op instanceof LtE and result = ">="
    or
    op instanceof Eq and result = "=="
    or
    op instanceof NotEq and result = "!="
}


/** DEPRECATED: 
 *  A test on the major version of the Python interpreter 
 * */
class VersionTest extends @py_flow_node {

    string toString() {
        result = "VersionTest"
    }

    VersionTest() {
        PointsTo::version_const(this, _, _)
    }

    predicate isTrue() {
        PointsTo::version_const(this, _, true)
    }

    AstNode getNode() {
        result = this.(ControlFlowNode).getNode()
    }

}

/** A guard on the major version of the Python interpreter */
class VersionGuard extends ConditionBlock {

    VersionGuard() {
        exists(VersionTest v |
            PointsTo::points_to(this.getLastNode(), _, v, _, _) or
            PointsTo::points_to(this.getLastNode(), _, _, _, v)
        )
    }

    predicate isTrue() {
        exists(VersionTest v |
            v.isTrue() |
            PointsTo::points_to(this.getLastNode(), _, v, _, _) or
            PointsTo::points_to(this.getLastNode(), _, _, _, v)
        )
    }

}

string os_name(StrConst s) {
    exists(string t | 
        t = s.getText() |
        t = "Darwin" and result = "darwin"
        or
        t = "Windows" and result = "win32"
        or
        t = "Linux" and result = "linux"
        or
        not t = "Darwin" and not t = "Windows" and not t = "Linux" and result = t
    )
}

predicate get_platform_name(Expr e) {
    exists(Attribute a, Name n | a = e and n = a.getObject() |
        n.getId() = "sys" and a.getName() = "platform"
    )
        or
    exists(Call c, Attribute a, Name n | 
        c = e and a = c.getFunc() and n = a.getObject() |
        a.getName() = "system" and n.getId() = "platform"
    )
}

predicate os_compare(ControlFlowNode f, string name) {
    exists(Compare c, Expr l, Expr r, Cmpop op |
        c = f.getNode() and
        l = c.getLeft() and
        r = c.getComparator(0) and
        op = c.getOp(0) |
        (op instanceof Eq or op instanceof Is)
        and
        ( get_platform_name(l) and name = os_name(r)
          or
          get_platform_name(r) and name = os_name(l)
        )
    )
}

class OsTest extends @py_flow_node {

    OsTest() {
        os_compare(this, _)
    }

    string getOs() {
        os_compare(this, result)
    }

    string toString() {
        result = "OsTest"
    }

    AstNode getNode() {
        result = this.(ControlFlowNode).getNode()
    }

}


class OsGuard extends ConditionBlock {

    OsGuard() {
        exists(OsTest t |
            PointsTo::points_to(this.getLastNode(), _, theBoolType(), t, _)
        )
    }

    string getOs() {
        exists(OsTest t |
            PointsTo::points_to(this.getLastNode(), _, theBoolType(), t, _) and result = t.getOs()
        )
    }

}


