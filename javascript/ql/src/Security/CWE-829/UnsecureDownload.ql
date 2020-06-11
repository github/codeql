/**
 * @name Download of sensitive file through unsecure connection
 * @description Downloading executeables and other sensitive files over an unsecure connection
 *              opens up for potential man-in-the-middle attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/unsecure-download
 * @tags security
 *       external/cwe/cwe-829
 */

// TODO:
// package.json urls (ALL package.json urls are sensitive.) - put in separate non-path query?
// Other protocols?
// Customizations module
// An integrity-check is a sanitizer (but what does such a check look like?)
import javascript
import DataFlow::PathGraph

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "HTTP/HTTPS" }

  override predicate isSource(DataFlow::Node source) {
    exists(string str | str = source.getStringValue() |
      str.regexpMatch("http://.*|ftp://.'") and
      exists(string suffix | suffix = unsafeSuffix() |
        str.suffix(str.length() - suffix.length() - 1).toLowerCase() = "." + suffix
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ClientRequest request | sink = request.getUrl())
    or
    exists(SystemCommandExecution cmd |
      cmd.getACommandArgument().getStringValue() = "curl" or
      cmd
          .getACommandArgument()
          .(StringOps::ConcatenationRoot)
          .getConstantStringParts()
          .regexpMatch("curl .*")
    |
      sink = cmd.getArgumentList().getALocalSource().getAPropertyWrite().getRhs() or
      sink = cmd.getACommandArgument().(StringOps::ConcatenationRoot).getALeaf()
    )
  }
}

/**
 * Gets a file-suffix
 */
string unsafeSuffix() {
  // including arcives, because they often contain source-code.
  result =
    ["exe", "dmg", "pkg", "tar.gz", "zip", "sh", "bat", "cmd", "app", "apk", "msi", "dmg", "tar.gz",
        "zip"]
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Download of file from $@.", source.getNode(), "HTTP source"
