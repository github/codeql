/**
 * @kind path-problem
 * This file tests the expected behaviour of flow summaries.
 */

import codeql.ruby.AST
import TestUtilities.InlineFlowTest
import PathGraph
private import codeql.ruby.dataflow.FlowSummary

/**
 * A convenience class for defining value (c.f. taint) flow summaries.
 */
bindingset[this]
abstract private class Summary extends SimpleSummarizedCallable {
  bindingset[this]
  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    this.propagates(input, output) and preservesValue = true
  }

  abstract predicate propagates(string input, string output);
}

/**
 * `Argument[self]` (input)
 */
private class S1 extends Summary {
  S1() { this = "s1" }

  override predicate propagates(string input, string output) {
    input = "Argument[self]" and output = "ReturnValue"
  }
}

/**
 * `Argument[self]` (output)
 */
private class S2 extends Summary {
  S2() { this = "s2" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "Argument[self]"
  }
}

/**
 * `Argument[<integer>]` (input, output)
 */
private class S3 extends Summary {
  S3() { this = "s3" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "Argument[1]"
  }
}

/**
 * `Argument[<integer>..]` (input)
 */
private class S4 extends Summary {
  S4() { this = "s4" }

  override predicate propagates(string input, string output) {
    input = "Argument[1..]" and output = "ReturnValue"
  }
}

/**
 * `Argument[<integer>..]` (output)
 */
private class S5 extends Summary {
  S5() { this = "s5" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "Argument[2..]"
  }
}

/**
 * `Argument[<string>]` (input)
 */
private class S6 extends Summary {
  S6() { this = "s6" }

  override predicate propagates(string input, string output) {
    input = "Argument[foo:]" and output = "ReturnValue"
  }
}

/**
 * `Argument[<string>]` (output)
 */
private class S7 extends Summary {
  S7() { this = "s7" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "Argument[foo:]"
  }
}

/**
 * `Argument[block]` (input)
 */
private class S8 extends Summary {
  S8() { this = "s8" }

  override predicate propagates(string input, string output) {
    input = "Argument[block].ReturnValue" and output = "ReturnValue"
  }
}

/**
 * `Argument[block]` (output)
 */
private class S9 extends Summary {
  S9() { this = "s9" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "Argument[block].Parameter[0]"
  }
}

/**
 * `Argument[any]` (input) 1
 */
private class S10 extends Summary {
  S10() { this = "s10" }

  override predicate propagates(string input, string output) {
    input = "Argument[any]" and output = "ReturnValue"
  }
}

/**
 * `Argument[any]` (input) 2
 * This tests that access paths using `Argument[any]` do not match blocks.
 * Test 10 contains an edge case example where blocks are matched, but this does
 * not appear to work in general.
 */
private class S11 extends Summary {
  S11() { this = "s11" }

  override predicate propagates(string input, string output) {
    input = "Argument[any].ReturnValue" and output = "ReturnValue"
  }
}

/**
 * `Argument[any]` (output)
 */
private class S12 extends Summary {
  S12() { this = "s12" }

  override predicate propagates(string input, string output) {
    input = "Argument[self]" and output = "Argument[any]"
  }
}

/**
 * `Argument[any-named]` (input)
 */
private class S13 extends Summary {
  S13() { this = "s13" }

  override predicate propagates(string input, string output) {
    input = "Argument[any-named]" and output = "ReturnValue"
  }
}

/**
 * `Argument[any-named]` (output)
 */
private class S14 extends Summary {
  S14() { this = "s14" }

  override predicate propagates(string input, string output) {
    input = "Argument[self]" and output = "Argument[any-named]"
  }
}

/**
 * `Argument[hash-splat]` (input) 1
 */
private class S15 extends Summary {
  S15() { this = "s15" }

  override predicate propagates(string input, string output) {
    input = "Argument[hash-splat]" and output = "ReturnValue"
  }
}

/**
 * `Argument[hash-splat]` (input) 2
 */
private class S16 extends Summary {
  S16() { this = "s16" }

  override predicate propagates(string input, string output) {
    input = "Argument[hash-splat].Element[any]" and output = "ReturnValue"
  }
}

/**
 * `Argument[hash-splat]` (output)
 */
private class S17 extends Summary {
  S17() { this = "s17" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "Argument[hash-splat]"
  }
}

/**
 * `Argument[hash-splat]` (output) 2
 */
private class S18 extends Summary {
  S18() { this = "s18" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "Argument[hash-splat].Element[any]"
  }
}
