import python
import semmle.python.frameworks.data.internal.ApiGraphModels as ApiGraphModels
import semmle.python.frameworks.data.ModelsAsData

class IsTesting extends ApiGraphModels::TestAllModels {
  IsTesting() { this = this }
}

query predicate warning = ModelOutput::getAWarning/0;
