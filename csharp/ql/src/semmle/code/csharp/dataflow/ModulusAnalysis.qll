/**
 * Provides inferences of the form: `e` equals `b + v` modulo `m` where `e` is
 * an expression, `b` is a `Bound` (typically zero or the value of an SSA
 * variable), and `v` is an integer in the range `[0 .. m-1]`.
 */

import semmle.code.csharp.dataflow.internal.rangeanalysis.ModulusAnalysisCommon
