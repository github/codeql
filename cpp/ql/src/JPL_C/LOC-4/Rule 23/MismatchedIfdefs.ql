/**
 * @name Mismatched conditional compilation directive
 * @description All #else, #elif and #endif preprocessor directives shall reside in the same file as the #if or #ifdef directive to which they are related.
 * @kind problem
 * @id cpp/jpl-c/mismatched-ifdefs
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

class FileWithDirectives extends File {
  FileWithDirectives() { exists(Directive d | d.getFile() = this) }

  int getDirectiveLine(Directive d) {
    d.getFile() = this and d.getLocation().getStartLine() = result
  }

  int getDirectiveIndex(Directive d) {
    exists(int line | line = this.getDirectiveLine(d) |
      line = rank[result](this.getDirectiveLine(_))
    )
  }

  int depth(Directive d) {
    exists(int index | index = this.getDirectiveIndex(d) |
      index = 1 and result = d.depthChange()
      or
      exists(Directive prev | this.getDirectiveIndex(prev) = index - 1 |
        result = d.depthChange() + this.depth(prev)
      )
    )
  }

  Directive lastDirective() { this.getDirectiveIndex(result) = max(this.getDirectiveIndex(_)) }
}

abstract class Directive extends PreprocessorDirective {
  abstract int depthChange();

  abstract predicate mismatched();

  int depth() { exists(FileWithDirectives f | f.depth(this) = result) }
}

class IfDirective extends Directive {
  IfDirective() {
    this instanceof PreprocessorIf or
    this instanceof PreprocessorIfdef or
    this instanceof PreprocessorIfndef
  }

  override int depthChange() { result = 1 }

  override predicate mismatched() { none() }
}

class ElseDirective extends Directive {
  ElseDirective() {
    this instanceof PreprocessorElif or
    this instanceof PreprocessorElse
  }

  override int depthChange() { result = 0 }

  override predicate mismatched() { this.depth() < 1 }
}

class EndifDirective extends Directive instanceof PreprocessorEndif {
  override int depthChange() { result = -1 }

  override predicate mismatched() { this.depth() < 0 }
}

from FileWithDirectives f, Directive d, string msg
where
  d.getFile() = f and
  if d.mismatched()
  then msg = "'" + d + "' has no matching #if in file " + f.getBaseName() + "."
  else (
    d = f.lastDirective() and
    d.depth() > 0 and
    msg = "File " + f.getBaseName() + " ends with " + d.depth() + " unterminated #if directives."
  )
select d, msg
