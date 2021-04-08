import semmle.code.cpp.Location
import semmle.code.cpp.Element

/**
 * A C/C++ preprocessor directive.
 *
 * For example: `#ifdef`, `#line`, or `#pragma`.
 */
class PreprocessorDirective extends Locatable, @preprocdirect {
  override string toString() { result = "Preprocessor directive" }

  override Location getLocation() { preprocdirects(underlyingElement(this), _, result) }

  string getHead() { preproctext(underlyingElement(this), result, _) }

  /**
   * Gets a preprocessor branching directive whose condition affects
   * whether this directive is performed.
   *
   * From a lexical point of view, this returns all `#if`, `#ifdef`,
   * `#ifndef`, or `#elif` directives which occur before this directive and
   * have a matching `#endif` which occurs after this directive.
   */
  PreprocessorBranch getAGuard() {
    exists(PreprocessorEndif e, int line |
      result.getEndIf() = e and
      e.getFile() = getFile() and
      result.getFile() = getFile() and
      line = this.getLocation().getStartLine() and
      result.getLocation().getStartLine() < line and
      line < e.getLocation().getEndLine()
    )
  }
}

private class TPreprocessorBranchDirective = @ppd_branch or @ppd_else or @ppd_endif;

/**
 * A C/C++ preprocessor branch related directive: `#if`, `#ifdef`,
 * `#ifndef`, `#elif`, `#else` or `#endif`.
 */
class PreprocessorBranchDirective extends PreprocessorDirective, TPreprocessorBranchDirective {
  /**
   * Gets the `#if`, `#ifdef` or `#ifndef` directive which matches this
   * branching directive.
   *
   * If this branch directive was unbalanced, then there will be no
   * result. Conversely, if the branch matches different `#if` directives
   * in different translation units, then there can be more than one
   * result.
   */
  PreprocessorBranch getIf() {
    result = this.(PreprocessorIf) or
    result = this.(PreprocessorIfdef) or
    result = this.(PreprocessorIfndef) or
    preprocpair(unresolveElement(result), underlyingElement(this))
  }

  /**
   * Gets the `#endif` directive which matches this branching directive.
   *
   * If this branch directive was unbalanced, then there will be no
   * result. Conversely, if the branch matched different `#endif`
   * directives in different translation units, then there can be more than
   * one result.
   */
  PreprocessorEndif getEndIf() { preprocpair(unresolveElement(getIf()), unresolveElement(result)) }

  /**
   * Gets the next `#elif`, `#else` or `#endif` matching this branching
   * directive.
   *
   * For example `somePreprocessorBranchDirective.getIf().getNext()` gets
   * the second directive in the same construct as
   * `somePreprocessorBranchDirective`.
   */
  PreprocessorBranchDirective getNext() {
    exists(PreprocessorBranch branch |
      this.getIndexInBranch(branch) + 1 = result.getIndexInBranch(branch)
    )
  }

  /**
   * Gets the index of this branching directive within the matching #if,
   * #ifdef or #ifndef.
   */
  private int getIndexInBranch(PreprocessorBranch branch) {
    this =
      rank[result](PreprocessorBranchDirective other |
        other.getIf() = branch
      |
        other order by other.getLocation().getStartLine()
      )
  }
}

/**
 * A C/C++ preprocessor branching directive: `#if`, `#ifdef`, `#ifndef`, or
 * `#elif`.
 *
 * A branching directive can have its condition evaluated at compile-time,
 * and as a result, the preprocessor will either take the branch, or not
 * take the branch.
 *
 * However, there are also situations in which a branch's condition isn't
 * evaluated.  The obvious case of this is when the directive is contained
 * within a branch which wasn't taken. There is also a much more subtle
 * case involving header guard branches: suitably clever compilers can
 * notice that a branch is a header guard, and can then subsequently ignore
 * a `#include` for the file being guarded. It is for this reason that
 * `wasTaken()` always holds on header guard branches, but `wasNotToken()`
 * rarely holds on header guard branches.
 */
class PreprocessorBranch extends PreprocessorBranchDirective, @ppd_branch {
  /**
   * Holds if at least one translation unit evaluated this directive's
   * condition and subsequently took the branch.
   */
  predicate wasTaken() { preproctrue(underlyingElement(this)) }

  /**
   * Holds if at least one translation unit evaluated this directive's
   * condition but then didn't take the branch.
   *
   * If `#else` is the next matching directive, then this means that the
   * `#else` was taken instead.
   */
  predicate wasNotTaken() { preprocfalse(underlyingElement(this)) }

  /**
   * Holds if this directive was either taken by all translation units
   * which evaluated it, or was not taken by any translation unit which
   * evaluated it.
   */
  predicate wasPredictable() { not (wasTaken() and wasNotTaken()) }
}

/**
 * A C/C++ preprocessor `#if` directive.
 *
 * For the related notion of a directive which causes branching (which
 * includes `#if`, plus also `#ifdef`, `#ifndef`, and `#elif`), see
 * `PreprocessorBranch`.
 */
class PreprocessorIf extends PreprocessorBranch, @ppd_if {
  override string toString() { result = "#if " + this.getHead() }
}

/**
 * A C/C++ preprocessor `#ifdef` directive.
 *
 * The syntax `#ifdef X` is shorthand for `#if defined(X)`.
 */
class PreprocessorIfdef extends PreprocessorBranch, @ppd_ifdef {
  override string toString() { result = "#ifdef " + this.getHead() }

  override string getAPrimaryQlClass() { result = "PreprocessorIfdef" }
}

/**
 * A C/C++ preprocessor `#ifndef` directive.
 *
 * The syntax `#ifndef X` is shorthand for `#if !defined(X)`.
 */
class PreprocessorIfndef extends PreprocessorBranch, @ppd_ifndef {
  override string toString() { result = "#ifndef " + this.getHead() }
}

/**
 * A C/C++ preprocessor `#else` directive.
 */
class PreprocessorElse extends PreprocessorBranchDirective, @ppd_else {
  override string toString() { result = "#else" }
}

/**
 * A C/C++ preprocessor `#elif` directive.
 */
class PreprocessorElif extends PreprocessorBranch, @ppd_elif {
  override string toString() { result = "#elif " + this.getHead() }
}

/**
 * A C/C++ preprocessor `#endif` directive.
 */
class PreprocessorEndif extends PreprocessorBranchDirective, @ppd_endif {
  override string toString() { result = "#endif" }
}

/**
 * A C/C++ preprocessor `#warning` directive.
 */
class PreprocessorWarning extends PreprocessorDirective, @ppd_warning {
  override string toString() { result = "#warning " + this.getHead() }
}

/**
 * A C/C++ preprocessor `#error` directive.
 */
class PreprocessorError extends PreprocessorDirective, @ppd_error {
  override string toString() { result = "#error " + this.getHead() }
}

/**
 * A C/C++ preprocessor `#undef` directive.
 */
class PreprocessorUndef extends PreprocessorDirective, @ppd_undef {
  override string toString() { result = "#undef " + this.getHead() }

  /**
   * Gets the name of the macro that is undefined.
   */
  string getName() { result = getHead() }
}

/**
 * A C/C++ preprocessor `#pragma` directive.
 */
class PreprocessorPragma extends PreprocessorDirective, @ppd_pragma {
  override string toString() {
    if exists(this.getHead()) then result = "#pragma " + this.getHead() else result = "#pragma"
  }
}

/**
 * A C/C++ preprocessor `#line` directive.
 */
class PreprocessorLine extends PreprocessorDirective, @ppd_line {
  override string toString() { result = "#line " + this.getHead() }
}
