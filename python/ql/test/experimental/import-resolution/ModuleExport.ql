import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.ImportResolution

from Module m, string name, DataFlow::Node defn
where
  ImportResolution::module_export(m, name, defn) and
  exists(m.getLocation().getFile().getRelativePath()) and
  not defn.getScope() = any(Module trace | trace.getName() = "trace")
select m.getName(), name, defn
