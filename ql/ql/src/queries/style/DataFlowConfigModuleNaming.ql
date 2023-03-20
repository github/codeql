/**
 * @id ql/dataflow-module-naming-convention
 * @name Data flow configuration module naming
 * @description The name of a data flow configuration module should end in `Config`
 * @kind problem
 * @problem.severity warning
 * @precision high
 */

import ql

/**
 * The DataFlow configuration module signatures (`ConfigSig`, `StateConfigSig`, `FullStateConfigSig`).
 */
class ConfigSig extends TypeExpr {
  ConfigSig() { this.getClassName() = ["ConfigSig", "StateConfigSig", "FullStateConfigSig"] }
}

/**
 * A module that implements a data flow configuration.
 */
class DataFlowConfigModule extends Module {
  DataFlowConfigModule() { this.getImplements(_) instanceof ConfigSig }
}

/**
 * A file that is part of the internal dataflow library or dataflow library
 * tests.
 */
class DataFlowInternalFile extends File {
  DataFlowInternalFile() {
    this.getRelativePath()
        .matches([
            "%/dataflow/internal/%", "%/dataflow/new/internal/%",
            "%/ql/test/library-tests/dataflow/%"
          ])
  }
}

from DataFlowConfigModule m
where
  not m.getFile() instanceof DataFlowInternalFile and
  not m.getName().matches("%Config")
select m, "Modules implementing a data flow configuration should end in `Config`."
