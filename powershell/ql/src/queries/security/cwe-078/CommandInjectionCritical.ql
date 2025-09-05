/**
 * @name Uncontrolled command line from param to CmdletBinding
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id powershell/microsoft/public/command-injection-critical
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import powershell
import semmle.code.powershell.security.CommandInjectionCustomizations::CommandInjection
import semmle.code.powershell.dataflow.TaintTracking
import semmle.code.powershell.dataflow.DataFlow

abstract class CriticalSource extends DataFlow::Node {
    /** Gets a string that describes the type of this flow source. */
    abstract string getSourceType();
}

class CmdletBindingParam extends CriticalSource {
    CmdletBindingParam(){
        exists(Attribute a, Function f | 
            a.getAName() = "CmdletBinding" and 
            f = a.getEnclosingFunction() and 
            this.asParameter() = f.getAParameter()    
        )
    }
    override string getSourceType(){
        result = "param to CmdletBinding function"
    }
}


private module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof CriticalSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Taint-tracking for reasoning about command-injection vulnerabilities.
 */
module CommandInjectionCriticalFlow = TaintTracking::Global<Config>;
import CommandInjectionCriticalFlow::PathGraph

from CommandInjectionCriticalFlow::PathNode source, CommandInjectionCriticalFlow::PathNode sink, CriticalSource sourceNode
where
  CommandInjectionCriticalFlow::flowPath(source, sink) and
  sourceNode = source.getNode()
select sink.getNode(), source, sink, "This command depends on a $@.", sourceNode,
  sourceNode.getSourceType()
