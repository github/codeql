/**
 * @kind graph
 */

import codeql_ruby.controlflow.internal.Cfg

class MyRelevantCfgNode extends RelevantCfgNode {
  MyRelevantCfgNode() { exists(this) }
}
