import powershell
import semmle.code.powershell.dataflow.TaintTracking
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.flowsources.FlowSources

abstract class InjectionSink extends DataFlow::Node {
    abstract string getSinkType();
}

class InvokeExpressionCall extends InjectionSink {
    InvokeExpressionCall() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c.getAnArgument() and
            c.getName() = ["Invoke-Expression", "iex", "Add-Type" ] )
    }
    override string getSinkType(){
        result = "call to Invoke-Expression"
    }   
}

class InvokeScriptSink extends InjectionSink {
    InvokeScriptSink() { 
        exists(API::Node call | 
            API::getTopLevelMember("executioncontext").getMember("invokecommand").getMethod("invokescript") = call and
            this = call.getArgument(_).asSink()
        )
    }
    override string getSinkType(){
        result = "call to InvokeScript"
    } 
}

class CreateNestedPipelineSink extends InjectionSink {
    CreateNestedPipelineSink() { 
        exists(API::Node call | 
            API::getTopLevelMember("host").getMember("runspace").getMethod("createnestedpipeline") = call and
            this = call.getArgument(_).asSink()
        )
    }
    override string getSinkType(){
        result = "call to CreateNestedPipeline"
    }
}

class AddScriptInvokeSink extends InjectionSink {
    AddScriptInvokeSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getAnArgument() and
            ie.getName() = "AddScript" and
            ie.getQualifier().(InvokeMemberExpr).getName() = "Create" and
            ie.getQualifier().getAChild().toString() = "PowerShell" and
            ie.getParent().(InvokeMemberExpr).getName() = "Invoke"
        )
    }
    override string getSinkType(){
        result = "call to AddScript"
    }
}

class PowershellSink extends InjectionSink {
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
    override string getSinkType(){
        result = "call to Powershell"
    }
}

class CmdSink extends InjectionSink {
    CmdSink() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c.getArgument(1) and
            c.getName() = "cmd" and
            c.getArgument(0).getValue().toString() = "/c" 
        )
    }   
    override string getSinkType(){
        result = "call to Cmd"
    }
}

class ForEachObjectSink extends InjectionSink {
    ForEachObjectSink() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c.getAnArgument() and
            c.getName() = "Foreach-Object" 
        )
    }   
    override string getSinkType(){
        result = "call to ForEach-Object"
    }
}

class InvokeSink extends InjectionSink {
    InvokeSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getCallee() or 
            this.asExpr().getExpr() = ie.getQualifier().getAChild*()
        )
    }   
    override string getSinkType(){
        result = "call to Invoke"
    }
}

class CreateScriptBlockSink extends InjectionSink {
    CreateScriptBlockSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getAnArgument() and
            ie.getName() = "Create" and
            ie.getQualifier().toString() = "ScriptBlock"
        )
    }   
    override string getSinkType(){
        result = "call to CreateScriptBlock"
    }
}

class NewScriptBlockSink extends InjectionSink {
    NewScriptBlockSink() { 
        exists(API::Node call | 
            API::getTopLevelMember("executioncontext").getMember("invokecommand").getMethod("newscriptblock") = call and
            this = call.getArgument(_).asSink()
        )
    }  
    override string getSinkType(){
        result = "call to NewScriptBlock"
    } 
}

class ExpandStringSink extends InjectionSink {
    ExpandStringSink() { 
        exists(API::Node call | this = call.getArgument(_).asSink() |
            API::getTopLevelMember("executioncontext").getMember("invokecommand").getMethod("expandstring") = call or
            API::getTopLevelMember("executioncontext").getMember("sessionstate").getMember("invokecommand").getMethod("expandstring") = call 
            
        )
    }  
    override string getSinkType(){
        result = "call to ExpandString"
    } 
}