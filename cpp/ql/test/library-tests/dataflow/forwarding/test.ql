import cpp
import utils.test.InlineExpectationsTest
import semmle.code.cpp.dataflow.ExternalFlow
import semmle.code.cpp.ir.IR

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

string getConstructorId(Constructor constructor) {
  exists(CppStyleComment comment, string filepath, int startline, int endline |
    comment.getLocation().hasLocationInfo(filepath, startline, _, endline, _) and
    constructor.getLocation().hasLocationInfo(filepath, startline, _, endline, _) and
    result = comment.getContents().suffix(2).trim()
  )
}

module AsDefinitionTest implements TestSig {
  string getARelevantTag() { result = "targets" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(CallInstruction call, Constructor constructor |
      constructor = ConstructorForwarding::getForwardingConstructor(call.getStaticCallTarget(), _) and
      element = call.toString() and
      tag = "targets" and
      value = quote(getConstructorId(constructor)) and
      location = call.getLocation()
    )
  }
}

import MakeTest<AsDefinitionTest>
