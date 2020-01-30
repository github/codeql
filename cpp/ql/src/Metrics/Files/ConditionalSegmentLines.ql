/**
 * @name Number of conditionally compiled lines
 * @description The number of lines that are subject to conditional
 *              compilation constraints defined using `#if`, `#ifdef`,
 *              and `#ifndef`.
 * @kind treemap
 * @id cpp/conditional-segment-lines
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 *       readability
 */

import cpp
import semmle.code.cpp.headers.MultipleInclusion

predicate preprocessorOpenCondition(PreprocessorDirective d, File f, int line) {
  (
    d instanceof PreprocessorIf or
    d instanceof PreprocessorIfdef or
    d instanceof PreprocessorIfndef
  ) and
  exists(Location l | l = d.getLocation() | f = l.getFile() and line = l.getStartLine())
}

predicate preprocessorCloseCondition(PreprocessorDirective d, File f, int line) {
  d instanceof PreprocessorEndif and
  exists(Location l | l = d.getLocation() | f = l.getFile() and line = l.getStartLine())
}

private predicate relevantLine(File f, int line) {
  preprocessorOpenCondition(_, f, line) or
  preprocessorCloseCondition(_, f, line)
}

predicate relevantDirective(PreprocessorDirective d, File f, int line) {
  preprocessorOpenCondition(d, f, line) or
  preprocessorCloseCondition(d, f, line)
}

private predicate relevantLineWithRank(File f, int rnk, int line) {
  line = rank[rnk](int l | relevantLine(f, l) | l)
}

private PreprocessorDirective next(PreprocessorDirective ppd) {
  exists(File f, int line, int rnk, int nextLine |
    relevantDirective(ppd, f, line) and
    relevantLineWithRank(f, rnk, line) and
    relevantLineWithRank(f, rnk + 1, nextLine) and
    relevantDirective(result, f, nextLine)
  )
}

private int level(PreprocessorDirective ppd) {
  relevantDirective(ppd, _, _) and
  not exists(PreprocessorDirective previous | ppd = next(previous)) and
  result = 0
  or
  exists(PreprocessorDirective previous |
    ppd = next(previous) and
    preprocessorOpenCondition(previous, _, _) and
    result = level(previous) + 1
  )
  or
  exists(PreprocessorDirective previous |
    ppd = next(previous) and
    preprocessorCloseCondition(previous, _, _) and
    result = level(previous) - 1
  )
}

private predicate openWithDepth(int depth, File f, PreprocessorDirective open, int line) {
  preprocessorOpenCondition(open, f, line) and
  depth = level(open) and
  depth < 2 // beyond 2, we don't care about the macros anymore
}

private predicate closeWithDepth(int depth, File f, PreprocessorDirective close, int line) {
  preprocessorCloseCondition(close, f, line) and
  depth = level(close) - 1 and
  depth < 2 // beyond 2, we don't care about the macros anymore
}

predicate length(PreprocessorDirective open, int length) {
  exists(int depth, File f, int start, int end |
    openWithDepth(depth, f, open, start) and
    end =
      min(PreprocessorDirective endif, int closeLine |
        closeWithDepth(depth, f, endif, closeLine) and
        closeLine > start
      |
        closeLine
      ) and
    length = end - start - 1
  )
}

predicate headerGuard(PreprocessorDirective notdef, File f) {
  exists(CorrectIncludeGuard g | notdef = g.getIfndef() and f = notdef.getFile())
}

predicate headerGuardChild(PreprocessorDirective open) {
  exists(File f, PreprocessorDirective headerGuard |
    headerGuard(headerGuard, f) and
    openWithDepth(1, f, open, _)
  )
}

predicate topLevelOpen(PreprocessorDirective open) {
  openWithDepth(0, _, open, _) and not headerGuard(open, _)
  or
  headerGuardChild(open)
}

from File f
where f.fromSource()
select f,
  sum(PreprocessorDirective open, int length |
    open.getFile() = f and
    topLevelOpen(open) and
    length(open, length)
  |
    length
  )
