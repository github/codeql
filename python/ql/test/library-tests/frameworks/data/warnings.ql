import python
import semmle.python.frameworks.data.internal.ApiGraphModels as ApiGraphModels
import semmle.python.frameworks.data.ModelsAsData

overlay[local]
class IsTesting extends ApiGraphModels::TestAllModels {
  IsTesting() { this = this }
}

query predicate warning = ModelOutput::getAWarning/0;
