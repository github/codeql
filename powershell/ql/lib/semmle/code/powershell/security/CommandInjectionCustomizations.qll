/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

private import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs
private import semmle.code.powershell.dataflow.flowsources.FlowSources
private import semmle.code.powershell.Cfg

module CommandInjection {
  /**
   * A data flow source for command-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this flow source. */
    abstract string getSourceType();
  }

  /**
   * A data flow sink for command-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { 
    abstract string getSinkType();
  }

  /**
   * A sanitizer for command-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of user input, considered as a flow source for command injection. */
  class FlowSourceAsSource extends Source instanceof SourceNode {
    override string getSourceType() { result = "user-provided value" }
  }

  /**
   * A command argument to a function that initiates an operating system command.
   */
  class SystemCommandExecutionSink extends Sink {
    SystemCommandExecutionSink() {
      // An argument to a call
      exists(DataFlow::CallNode call |
        call.getName() = ["Invoke-Expression", "iex"] and
        call.getAnArgument() = this
      )
      or
      // Or the call command itself in case it's a use of operator &.
      any(DataFlow::CallOperatorNode call).getCommand() = this
    }
    override string getSinkType() {
      result = "call to Invoke-Expression"
    }
  }

  class AddTypeSink extends Sink {
    AddTypeSink() {
      exists(DataFlow::CallNode call |
        call.getName() = "Add-Type" and
        call.getAnArgument() = this
      )
    }
    override string getSinkType() {
      result = "call to Add-Type"
    } 
  }

  class InvokeScriptSink extends Sink {
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

class CreateNestedPipelineSink extends Sink {
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

class AddScriptInvokeSink extends Sink {
  AddScriptInvokeSink() { 
      exists(InvokeMemberExpr addscript, InvokeMemberExpr create | 
          this.asExpr().getExpr() = addscript.getAnArgument() and
          addscript.getName() = "AddScript" and
          create.getName() = "Create" and

          addscript.getQualifier().(InvokeMemberExpr) = create and
          create.getQualifier().(TypeNameExpr).getName() = "PowerShell"
      )
  }
  override string getSinkType(){
      result = "call to AddScript"
  }
}

class PowershellSink extends Sink {
    PowershellSink() { 
        exists( CmdCall c |        
            c.getName() = "powershell" | 
            (
                this.asExpr().getExpr() = c.getArgument(1) and
                c.getArgument(0).getValue().asString() = "-command"
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

class CmdSink extends Sink {
    CmdSink() { 
        exists(CmdCall c | 
            this.asExpr().getExpr() = c.getArgument(1) and
            c.getName() = "cmd" and
            c.getArgument(0).getValue().asString() = "/c" 
        )
    }   
    override string getSinkType(){
        result = "call to Cmd"
    }
}

class ForEachObjectSink extends Sink {
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

class InvokeSink extends Sink {
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

class CreateScriptBlockSink extends Sink {
    CreateScriptBlockSink() { 
        exists(InvokeMemberExpr ie | 
            this.asExpr().getExpr() = ie.getAnArgument() and
            ie.getName() = "Create" and
            ie.getQualifier().(TypeNameExpr).getName() = "ScriptBlock"
        )
    }   
    override string getSinkType(){
        result = "call to CreateScriptBlock"
    }
}

class NewScriptBlockSink extends Sink {
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

class ExpandStringSink extends Sink {
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

  private class ExternalCommandInjectionSink extends Sink {
    ExternalCommandInjectionSink() {
      this = ModelOutput::getASinkNode("command-injection").asSink()
    }
    override string getSinkType() {
      result = "external command injection"
    }
  }

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
        exists(ExpandableStringExpr e, VarReadAccess v | 
            v = this.asExpr().getExpr()  and
            e.getUnexpandedValue().matches("%'$" + v.getVariable().getName() + "'%") and
            e.getAnExpr() = v
        )
    }
  }
}

