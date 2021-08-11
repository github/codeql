/**
 * @kind graph
 */

import codeql.ruby.controlflow.internal.Cfg

class MyRelevantCfgNode extends RelevantCfgNode {
  MyRelevantCfgNode() { exists(this) }
}
