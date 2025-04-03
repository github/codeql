/**
 * @name User Input to Invoke-Expression 
 * @description Finding cases where the user input is passed an Invoke-Expression command
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id powershell/microsoft/public/user-input-to-invoke-expression
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import powershell
import semmle.code.powershell.dataflow.TaintTracking
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs

private module TestConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { 
        exists(CmdCall c | 
            c.getName() = "Read-Host" and
            source.asExpr().getExpr() = c) }
  
    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
    predicate isBarrier(DataFlow::Node node) {node instanceof Sanitizer}
}

abstract class Source extends DataFlow::Node {}

class ReadHostSource extends Source {
    ReadHostSource() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c and
            c.getName() = "Read-Host" )
    }   
}

class GetContentSource extends Source {
    GetContentSource() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c and
            c.getName() = "Get-Content" )
    }   
}

class ValueFromPipelineSource extends Source {
    ValueFromPipelineSource() { 
        exists(Parameter p |  
            p.getAnAttribute().toString() = "ValueFromPipeline" and 
            this.asExpr().getExpr() = p.getAnAccess()   
        )
    }   
}

abstract class Sink extends DataFlow::Node {}

class InvokeExpressionCall extends Sink {
    InvokeExpressionCall() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c.getAnArgument() and
            c.getName() = ["Invoke-Expression", "iex", "Add-Type" ] )
    }   
}

class InvokeScriptSink extends Sink {
    InvokeScriptSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getAnArgument() and
            ie.getName() = "InvokeScript" and
            ie.getQualifier().toString() = "InvokeCommand" and
            ie.getQualifier().getAChild().toString() = "executioncontext"
        )
    }
}

class CreateNestedPipelineSink extends Sink {
    CreateNestedPipelineSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getAnArgument() and
            ie.getName() = "CreateNestedPipeline" and
            ie.getQualifier().toString() = "InvokeCommand" and
            ie.getQualifier().getAChild().toString() = "executioncontext")
    }
}

class AddScriptInvokeSink extends Sink {
    AddScriptInvokeSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getAnArgument() and
            ie.getName() = "AddScript" and
            ie.getQualifier().(InvokeMemberExpr).getName() = "Create" and
            ie.getQualifier().getAChild().toString() = "PowerShell" and
            ie.getParent().(InvokeMemberExpr).getName() = "Invoke"
        )
    }
}

abstract class Sanitizer extends DataFlow::Node {}

// class TypedParameterSanitizer extends Sanitizer{
//     TypedParameterSanitizer() { 
//         exists(Function f, CmdCall c, Parameter p, Argument a | 
//             p = f.getAParameter() and
//             a = c.getAnArgument() and 
//             p.getName().toLowerCase() = a.getName() and 
//             p.getStaticType() != "Object" and
//             c.getName() = f.getName() and 
            
//             this.asExpr().getExpr() = a
//         )
//     }
// }

class SingleQuoteSanitizer extends Sanitizer {
    SingleQuoteSanitizer() { 
        exists(Expr e, VarReadAccess v | 
            e = this.asExpr().getExpr().getParent() and
            e.toString().matches("%'$" + v.getVariable().getName() + "'%")
        )
    }
}

module TestFlow = TaintTracking::Global<TestConfig>;
import TestFlow::PathGraph

// from TestFlow::PathNode source, TestFlow::PathNode sink
// where
//     TestFlow::flowPath(source, sink) and 
//     sink.getNode().asExpr().getExpr().getLocation().getFile().getBaseName() = "sanitizers.ps1" 
// select sink.getNode(), source, sink, "Flow from user input to Invoke-Expression"

// from Function f, CmdCall c 
// where f.getLocation().getFile().getBaseName() = "sanitizers.ps1" 
// select f, f.getAParameter().getStaticType(), f.getAParameter().getName()


//TBD, waiting on mathias on how to connect f and c
// from Function f, CmdCall c, Parameter p, Argument a
// where 
// p = f.getAParameter() and
// a = c.getAnArgument() and 
// p.getName().toLowerCase() = a.getName() and 
// p.getStaticType() != "Object" and
// c.getName() = f.getName()
// select a, "argument has a specified static type"

// from Argument a, VarReadAccess v
// where a.getAChild() = v and 
// v.getVariable().getName() = "UserInput"
// select a, v

// from Argument e 
// where e.getLocation().getFile().getBaseName() = "sanitizers.ps1" 
// and e.getLocation().getStartLine() = 14
// select e, e.getAChild(), e.getParent(), e.toString()


from Parameter p 
where p.getLocation().getFile().getBaseName() = "userinput.ps1" 
// p.getAnAttribute().toString() = "ValueFromPipeline" and 

select p, p.getName()

// from Expr e 
// where e.getLocation().getFile().getBaseName() = "userinput.ps1"
// select e, e.getAQlClass()

// from InvokeMemberExpr ie
// where
// ie.getLocation().getStartLine() = 28 and ie.getName() = "AddScript"
// select ie, ie.getName(), ie.getQualifier().toString(), ie.getQualifier().getAChild().toString(), ie.getParent().(InvokeMemberExpr).getName() 