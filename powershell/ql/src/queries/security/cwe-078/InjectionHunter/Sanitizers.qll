import powershell 
import semmle.code.powershell.dataflow.TaintTracking
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs


abstract class Sanitizer extends DataFlow::Node {}

class TypedParameterSanitizer extends Sanitizer {
    TypedParameterSanitizer() {
      exists(Function f, Parameter p |
        p = f.getAParameter() and
        p.getStaticType() != "Object" and
        this.asParameter() = p
      )
    }
}

class SingleQuoteSanitizer extends Sanitizer {
    SingleQuoteSanitizer() { 
        exists(Expr e, VarReadAccess v | 
            e = this.asExpr().getExpr().getParent() and
            e.toString().matches("%'$" + v.getVariable().getName() + "'%")
        )
    }
}
