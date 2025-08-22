/**
 * @kind path-problem
 * This file tests that flow summaries behave as described in `ql/docs/flow-summaries.md`.
 */

import codeql.ruby.AST
import utils.test.InlineFlowTest
import DefaultFlowTest
import PathGraph
private import codeql.ruby.dataflow.FlowSummary

/**
 * A convenience class for defining value (c.f. taint) flow summaries.
 */
abstract private class Summary extends SimpleSummarizedCallable {
  bindingset[this]
  Summary() { any() }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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
 * `Argument[splat]` (input) 1
 */
private class S17 extends Summary {
  S17() { this = "s17" }

  override predicate propagates(string input, string output) {
    input = "Argument[splat]" and output = "ReturnValue"
  }
}

/**
 * `Argument[splat]` (input) 2
 */
private class S18 extends Summary {
  S18() { this = "s18" }

  override predicate propagates(string input, string output) {
    input = "Argument[splat].Element[any]" and output = "ReturnValue"
  }
}

/** `Element[?]` (input) */
private class S19 extends Summary {
  S19() { this = "s19" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[?]" and output = "ReturnValue"
  }
}

/** `Element[?]` (output) */
private class S20 extends Summary {
  S20() { this = "s20" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[?]"
  }
}

/** `Element[any]` (input) */
private class S21 extends Summary {
  S21() { this = "s21" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[any]" and output = "ReturnValue"
  }
}

/** `Element[any]` (output) */
private class S22 extends Summary {
  S22() { this = "s22" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[any]"
  }
}

/** `Element[<integer>]` (input) */
private class S23 extends Summary {
  S23() { this = "s23" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[0]" and output = "ReturnValue"
  }
}

/** `Element[<integer>]` (output) */
private class S24 extends Summary {
  S24() { this = "s24" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[0]"
  }
}

/** `Element[<integer>!]` (input) */
private class S25 extends Summary {
  S25() { this = "s25" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[0!]" and output = "ReturnValue"
  }
}

/** `Element[<integer>!]` (output) */
private class S26 extends Summary {
  S26() { this = "s26" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[0!]"
  }
}

/** `Element[<integer>..]` (input) */
private class S27 extends Summary {
  S27() { this = "s27" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[1..]" and output = "ReturnValue"
  }
}

/** `Element[<integer>..]` (output) */
private class S28 extends Summary {
  S28() { this = "s28" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[1..]"
  }
}

/** `Element[<integer>..!]` (input) */
private class S29 extends Summary {
  S29() { this = "s29" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[1..!]" and output = "ReturnValue"
  }
}

/** `Element[<integer>..!]` (output) */
private class S30 extends Summary {
  S30() { this = "s30" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[1..!]"
  }
}

/**
 * `Element[<string>]` (input) 1
 *
 * In general, the key format must match the output of `ConstantValue::serialize/0`.
 * For example, symbol keys must be prefixed by `:`.
 */
private class S31 extends Summary {
  S31() { this = "s31" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[:foo]" and output = "ReturnValue"
  }
}

/**
 * `Element[<string>]` (input) 2
 *
 * String keys must be wrapped double quotes.
 */
private class S32 extends Summary {
  S32() { this = "s32" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[\"foo\"]" and output = "ReturnValue"
  }
}

/**
 * `Element[<string>]` (input) 3
 *
 * `nil`, `true` and `false` keys can be written verbatim.
 */
private class S33 extends Summary {
  S33() { this = "s33" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[nil,true,false]" and output = "ReturnValue"
  }
}

/** `Element[<string>]` (output) 1 */
private class S35 extends Summary {
  S35() { this = "s35" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[:foo]"
  }
}

/** `Element[<string>]` (output) 2 */
private class S36 extends Summary {
  S36() { this = "s36" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[\"foo\"]"
  }
}

/** `Element[<string>]` (output) 3 */
private class S37 extends Summary {
  S37() { this = "s37" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[true]"
  }
}

/**
 * `Element[<string>!]` (input)
 */
private class S38 extends Summary {
  S38() { this = "s38" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Element[\"foo\"!]" and output = "ReturnValue"
  }
}

/**
 * `Element[<string>!]` (output)
 */
private class S39 extends Summary {
  S39() { this = "s39" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Element[:foo!]"
  }
}

/**
 * `Field[@<string>]` (input)
 */
private class S40 extends Summary {
  S40() { this = "s40" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].Field[@foo]" and output = "ReturnValue"
  }
}

/**
 * `Field[@<string>]` (output)
 */
private class S41 extends Summary {
  S41() { this = "s41" }

  override predicate propagates(string input, string output) {
    input = "Argument[0]" and output = "ReturnValue.Field[@foo]"
  }
}

/**
 * `WithElement`
 */
private class S42 extends Summary {
  S42() { this = "s42" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithElement[0]" and output = "ReturnValue"
  }
}

/**
 * `WithElement[!]`
 */
private class S43 extends Summary {
  S43() { this = "s43" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithElement[0!]" and output = "ReturnValue"
  }
}

/**
 * `WithoutElement` 1
 */
private class S44 extends Summary {
  S44() { this = "s44" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithoutElement[0]" and output = "Argument[0]"
  }
}

/**
 * `WithoutElement` 2
 */
private class S45 extends Summary {
  S45() { this = "s45" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithoutElement[0!]" and output = "Argument[0]"
  }
}

/**
 * `WithoutElement` 3
 */
private class S46 extends Summary {
  S46() { this = "s46" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithoutElement[0]" and output = "ReturnValue"
  }
}

/**
 * `WithoutElement` 4
 */
private class S47 extends Summary {
  S47() { this = "s47" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithoutElement[:foo].WithElement[any]" and output = "ReturnValue"
  }
}

/**
 * `WithoutElement` 5
 */
private class S48 extends Summary {
  S48() { this = "s48" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithoutElement[:foo]" and output = "ReturnValue"
  }
}

/**
 * `WithoutElement` 6
 */
private class S49 extends Summary {
  S49() { this = "s49" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithoutElement[:foo!]" and output = "ReturnValue"
  }
}

/**
 * `WithoutElement` 7
 */
private class S50 extends Summary {
  S50() { this = "s50" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithoutElement[:foo]" and output = "Argument[0]"
  }
}

/**
 * `WithoutElement` 8
 */
private class S51 extends Summary {
  S51() { this = "s51" }

  override predicate propagates(string input, string output) {
    input = "Argument[0].WithoutElement[:foo!]" and output = "Argument[0]"
  }
}

/**
 * `WithoutElement` 9
 */
private class S52 extends Summary {
  S52() { this = "s52" }

  override predicate propagates(string input, string output) {
    input = "Argument[self].WithoutElement[:foo]" and output = "Argument[self]"
  }
}

/**
 * `WithoutElement` 10
 */
private class S53 extends Summary {
  S53() { this = "s53" }

  override predicate propagates(string input, string output) {
    input = "Argument[self].WithoutElement[:foo]" and
    output = "ReturnValue"
  }
}

/**
 * `WithoutElement` 11
 */
private class S54 extends Summary {
  S54() { this = "s54" }

  override predicate propagates(string input, string output) {
    input = "Argument[self].WithoutElement[:foo].WithElement[any]" and
    output = "ReturnValue"
  }
}
