/**
 * @name Potential file system race condition
 * @description Separately checking the state of a file before operating
 *              on it may allow an attacker to modify the file between
 *              the two operations.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.7
 * @precision medium
 * @id js/file-system-race
 * @tags security
 *       external/cwe/cwe-367
 */

import javascript

/**
 * A call that checks a property of some file.
 */
class FileCheck extends DataFlow::CallNode {
  string member;

  FileCheck() {
    member =
      [
        "open", "openSync", "exists", "existsSync", "stat", "statSync", "lstat", "lstatSync",
        "fstat", "fstatSync", "access", "accessSync"
      ] and
    this = NodeJSLib::FS::moduleMember(member).getACall()
  }

  DataFlow::Node getPathArgument() { result = this.getArgument(0) }

  /** Holds if this call is a simple existence check for a file. */
  predicate isExistsCheck() { member = ["exists", "existsSync"] }
}

/**
 * A call that modifies or otherwise interacts with a file.
 */
class FileUse extends DataFlow::CallNode {
  string member;

  FileUse() {
    member =
      [
        // these are the six methods that accept file paths and file descriptors
        "readFile", "readFileSync", "writeFile", "writeFileSync", "appendFile", "appendFileSync",
        // don't use "open" after e.g. "access"
        "open", "openSync"
      ] and
    this = NodeJSLib::FS::moduleMember(member).getACall()
  }

  DataFlow::Node getPathArgument() { result = this.getArgument(0) }

  /** Holds if this call reads from a file. */
  predicate isFileRead() { member = ["readFile", "readFileSync"] }
}

/**
 * Gets a reference to a file-handle from a call to `open` or `openSync`.
 */
DataFlow::SourceNode getAFileHandle(DataFlow::TypeTracker t) {
  t.start() and
  (
    result = NodeJSLib::FS::moduleMember("openSync").getACall()
    or
    result =
      NodeJSLib::FS::moduleMember("open")
          .getACall()
          .getLastArgument()
          .getAFunctionValue()
          .getParameter(1)
  )
  or
  exists(DataFlow::TypeTracker t2 | result = getAFileHandle(t2).track(t2, t))
}

/**
 * Holds if `check` and `use` operate on the same file.
 */
predicate checkAndUseOnSame(FileCheck check, FileUse use) {
  exists(string path |
    check.getPathArgument().mayHaveStringValue(path) and
    use.getPathArgument().mayHaveStringValue(path)
  )
  or
  AccessPath::getAnAliasedSourceNode(check.getPathArgument()).flowsTo(use.getPathArgument())
}

/**
 * Holds if `check` happens before `use`.
 */
pragma[inline]
predicate useAfterCheck(FileCheck check, FileUse use) {
  check.getCallback(_).getFunction() = use.getContainer()
  or
  exists(BasicBlock bb |
    check.getBasicBlock() = bb and
    use.getBasicBlock() = bb and
    exists(int i, int j |
      bb.getNode(i) = check.asExpr() and
      bb.getNode(j) = use.asExpr() and
      i < j
    )
  )
  or
  check.getBasicBlock().(ReachableBasicBlock).strictlyDominates(use.getBasicBlock())
}

from FileCheck check, FileUse use
where
  checkAndUseOnSame(check, use) and
  useAfterCheck(check, use) and
  not (check.isExistsCheck() and use.isFileRead()) and // a read after an exists check is fine
  not getAFileHandle(DataFlow::TypeTracker::end()).flowsTo(use.getPathArgument())
select use, "The file may have changed since it $@.", check, "was checked"
