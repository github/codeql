/**
 * @name Globally readable internal file vulnerability
 * @description Check whether there are internal files in the App that can be read and written by any other App.
 * @kind problem
 * @id globally-readable-internal-file-vulnerability
 * @problem.severity error
 * @security-severity 8.2
 * @precision high
 * @tags security
 *       external/cwe/cwe-1025
 */

import java
import semmle.code.java.dataflow.FlowSources


/** The class `android.context.ContextWrapper`. */
class AndroidContextWrapper extends RefType{
    AndroidContextWrapper(){
        this.hasQualifiedName("android.content", "ContextWrapper")
    }
}

/** A method call to `context.openFileOutput`. */
class OpenFileOutputMethodAccess extends Method {
    OpenFileOutputMethodAccess() {
      this.hasName("openFileOutput") and
      this.getDeclaringType() instanceof AndroidContextWrapper
    }
}

class FileReadAndWriteNode extends  DataFlow::Node{
    FileReadAndWriteNode(){
        exists(OpenFileOutputMethodAccess m | 
            m.getParameter(1).getAnArgument()=this.asExpr() and 
            not (this.asExpr().toString()="0" or 
                this.asExpr().toString()="Context.MODE_PRIVATE" or 
                this.asExpr().toString()="MODE_PRIVATE")
            )
    }
 }


from FileReadAndWriteNode parameter
select  parameter, "Wrong mode parameter of openFileOutput() function   "
