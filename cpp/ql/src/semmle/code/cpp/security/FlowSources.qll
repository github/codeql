/**
 * Provides classes representing various flow sources for taint tracking.
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.IR

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();
}

class FileDescriptorTaintedCallSource extends RemoteFlowSource {
  FileDescriptorTaintedCallSource() {
    asExpr().(Call).getTarget().hasGlobalName(["fgets", "gets"])
  }

  override string getSourceType() { result = "Data read from a FILE* or file descriptor" }
}

class FileTaintedParameterSource extends RemoteFlowSource, DataFlow::DefinitionByReferenceNode {
  FileTaintedParameterSource() {
    exists(string fname, int arg |
      getParameter().getFunction().hasGlobalOrStdName(fname) and
      getParameter().getIndex() = arg
    |
      fname = "fread" and arg = 0
      or
      fname = "fgets" and arg = 0
      or
      fname = "fgetws" and arg = 0
      or
      fname = "gets" and arg = 0
      or
      fname = "scanf" and arg >= 1
      or
      fname = "fscanf" and arg >= 2
    )
    or
    exists(string fname, int arg |
      getParameter().getFunction().hasGlobalOrStdName(fname) and
      getParameter().getIndex() = arg
    |
      fname = "read" and arg = 1
      or
      fname = "getaddrinfo" and arg = 3
      or
      fname = "recv" and arg = 1
      or
      fname = "recvfrom" and
      (arg = 1 or arg = 4 or arg = 5)
      or
      fname = "recvmsg" and arg = 1
    )
  }

  override string getSourceType() { result = "Data read from a FILE* or file descriptor" }
}
