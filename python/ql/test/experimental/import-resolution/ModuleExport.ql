import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.ImportResolution

from Module m, string name, DataFlow::Node defn
where
  ImportResolution::module_export(m, name, defn) and
  exists(m.getLocation().getFile().getRelativePath()) and
  not defn.getScope() = any(Module trace | trace.getName() = "trace") and
  not m.getName() = "main" and
  // Since we test on both Python 2 and Python 3, but `namespace_package` is not allowed
  // on Python 2 because of the missing `__init__.py` files, we remove those results
  // from Python 3 tests as well. One alternative is to only run these tests under
  // Python 3, but that does not seems like a good solution -- we could easily miss a
  // Python 2 only regression then :O
  not m.getName() = "namespace_package.namespace_module"
select m.getName(), name, defn
