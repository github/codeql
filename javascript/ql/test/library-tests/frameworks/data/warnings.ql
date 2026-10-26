import javascript
import semmle.javascript.frameworks.data.internal.ApiGraphModels as ApiGraphModels

overlay[local]
class IsTesting extends ApiGraphModels::TestAllModels {
  IsTesting() { this = this }
}

query predicate warning = ModelOutput::getAWarning/0;
