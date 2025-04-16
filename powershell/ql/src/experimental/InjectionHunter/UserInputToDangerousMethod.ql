/**
 * @name User Input to Invoke-Expression 
 * @description Finding cases where the user input is passed an dangerous method that can lead to RCE
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
import semmle.code.powershell.dataflow.flowsources.FlowSources

import Sanitizers

private module TestConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { 
        source instanceof SourceNode or 
        source instanceof Source
    }
  
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
        exists(API::Node call | 
            API::getTopLevelMember("executioncontext").getMember("invokecommand").getMethod("invokescript") = call and
            this = call.getArgument(_).asSink()
        )
    }
}

class CreateNestedPipelineSink extends Sink {
    CreateNestedPipelineSink() { 
        exists(API::Node call | 
            API::getTopLevelMember("host").getMember("runspace").getMethod("createnestedpipeline") = call and
            this = call.getArgument(_).asSink()
        )
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

class PowershellSink extends Sink {
    PowershellSink() { 
        exists( CmdCall c |        
            c.getName() = "powershell" | 
            (
                this.asExpr().getExpr() = c.getArgument(1) and
                c.getArgument(0).getValue().toString() = "-command"
            ) or 
            (
                this.asExpr().getExpr() = c.getArgument(0)
            )
        )
    }
}

class CmdSink extends Sink {
    CmdSink() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c.getArgument(1) and
            c.getName() = "cmd" and
            c.getArgument(0).getValue().toString() = "/c" 
        )
    }   
}

class ForEachObjectSink extends Sink {
    ForEachObjectSink() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c.getAnArgument() and
            c.getName() = "Foreach-Object" 
        )
    }   
}

class InvokeSink extends Sink {
    InvokeSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getCallee() or 
            this.asExpr().getExpr() = ie.getQualifier().getAChild*()
        )
    }   
}

class CreateScriptBlockSink extends Sink {
    CreateScriptBlockSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getAnArgument() and
            ie.getName() = "Create" and
            ie.getQualifier().toString() = "ScriptBlock"
        )
    }   
}

class NewScriptBlockSink extends Sink {
    NewScriptBlockSink() { 
        exists(API::Node call | 
            API::getTopLevelMember("executioncontext").getMember("invokecommand").getMethod("newscriptblock") = call and
            this = call.getArgument(_).asSink()
        )
    }   
}

class ExpandStringSink extends Sink {
    ExpandStringSink() { 
        exists(API::Node call | this = call.getArgument(_).asSink() |
            API::getTopLevelMember("executioncontext").getMember("invokecommand").getMethod("expandstring") = call or
            API::getTopLevelMember("executioncontext").getMember("sessionstate").getMember("invokecommand").getMethod("expandstring") = call 
            
        )
    }   
}

module TestFlow = TaintTracking::Global<TestConfig>;
import TestFlow::PathGraph

from TestFlow::PathNode source, TestFlow::PathNode sink
where
    TestFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Flow from user input to dangerous method"

// from CmdCall c 
// where c.getName() = "cmd" 
// and c.getArgument(0).getValue().toString() = "/c" 
// select c.getArgument(1)

// from InvokeMemberExpr ie 
// where ie.getName() = "Create" and 
// ie.getQualifier().toString() = "ScriptBlock"
// select ie, ie.getQualifier(), ie.getAnArgument()

// from API::Node call 
// where API::getTopLevelMember("executioncontext").getMember("invokecommand").getMethod("newscriptblock") = call
// select call, call.getArgument(_).asSink()

// from Expr e 
// where e.getLocation().getFile().getBaseName() = "InjectionHunterTests.ps1"
// and e.getLocation().getStartLine() = 106
// select e, e.getAQlClass()


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

// from PipelineParameter p 
// where p.getLocation().getFile().getBaseName() = "userinput.ps1"
// select p, p.getName(), p.getAChild()

// from Attribute a
// select a, a.getParent(), a.getParent().getAQlClass(), a.getANamedArgument()



// from Expr e 
// where e.getLocation().getFile().getBaseName() = "sanitizers.ps1"
// and e.getLocation().getStartLine() = 31
// select e, e.getAQlClass()

// from InvokeMemberExpr ie
// where
// ie.getLocation().getStartLine() = 28 and ie.getName() = "AddScript"
// select ie, ie.getName(), ie.getQualifier().toString(), ie.getQualifier().getAChild().toString(), ie.getParent().(InvokeMemberExpr).getName() 