/**
 * Provides sign analysis to determine whether expression are always positive
 * or negative.
 *
 * The analysis is implemented as an abstract interpretation over the
 * three-valued domain `{negative, zero, positive}`.
 */

import semmle.code.java.dataflow.internal.rangeanalysis.SignAnalysisCommon
