import go
private import semmle.go.dataflow.SsaImpl as SsaInternals
import utils.test.InlineExpectationsTest

module ReadKindsTest implements TestSig {
  string getARelevantTag() {
    result = ["explicit", "implicit", "flow", "access-path", "implicit-return", "implicit-phi"]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SsaSourceVariable variable |
      location = variable.getLocation() and
      element = variable.getName()
    |
      tag = "explicit" and
      value =
        count(Expr read |
          read = any(SsaDefinition def | def.getSourceVariable() = variable).getARead()
        ).toString()
      or
      tag = "implicit" and
      value =
        count(BasicBlock bb, int i |
          SsaInternals::Ssa::ssaDefReachesImplicitRead(any(SsaDefinition def |
              def.getSourceVariable() = variable
            ), bb, i)
        ).toString()
      or
      tag = "flow" and
      value =
        count(DataFlow::ReadNode read |
          read.readsSsaDefinition(any(SsaDefinition def | def.getSourceVariable() = variable))
        ).toString()
      or
      tag = "access-path" and
      value =
        count(DataFlow::Node read |
          exists(SsaWithFields path |
            path.getBaseDefinition().getSourceVariable() = variable and
            read = path.getAUse()
          )
        ).toString()
    )
    or
    exists(SsaDefinition def, DataFlow::ReadNode read |
      read.readsSsaDefinition(def) and
      read.asInstruction() instanceof IR::ReadResultInstruction and
      element = def.toString() and
      value = ""
    |
      def instanceof SsaPhiDefinition and
      location = def.getSourceVariable().getLocation() and
      tag = "implicit-phi"
      or
      not def instanceof SsaPhiDefinition and
      location = def.getLocation() and
      tag = "implicit-return"
    )
  }
}

import MakeTest<ReadKindsTest>
