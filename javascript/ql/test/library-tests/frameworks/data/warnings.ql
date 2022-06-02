import javascript
import semmle.javascript.frameworks.data.internal.AccessPathSyntax as AccessPathSyntax
import semmle.javascript.frameworks.data.internal.ApiGraphModels as ApiGraphModels

private class InvalidTypeModel extends ModelInput::TypeModelCsv {
  override predicate row(string row) {
    row =
      [
        "test;TooManyColumns;;;Member[Foo].Instance;too;many;columns", //
        "test;TooFewColumns", //
        "test;X;test;Y;Method[foo].Arg[0]", //
        "test;X;test;Y;Method[foo].Argument[0-1]", //
        "test;X;test;Y;Method[foo].Argument[*]", //
        "test;X;test;Y;Method[foo].Argument", //
        "test;X;test;Y;Method[foo].Member", //
      ]
  }
}

class IsTesting extends ApiGraphModels::TestAllModels {
  IsTesting() { this = this }
}

query predicate warning = ModelOutput::getAWarning/0;
