/**
 * Provides classes for dealing with AngularJS expressions (e.g. `<div id="{{myId}}"/>`).
 *
 * INTERNAL: Do not import this module directly, import `AngularJS` instead.
 *
 * NOTE: The API of this library is not stable yet and may change in
 *       the future.
 */

import javascript

/**
 * Extensible class for AngularJS expression source providers (e.g. `id="{{myId}}"` of `<div id="{{myId}}" class="left"/>`).
 */
abstract class NgSourceProvider extends Locatable {
  /**
   * Holds if this element provides the source as `src` for an AngularJS expression at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   */
  abstract predicate providesSourceAt(
    string src, string path, int startLine, int startColumn, int endLine, int endColumn
  );

  /**
   * Gets the enclosing element of the provided source.
   */
  abstract DOM::ElementDefinition getEnclosingElement();
}

/**
 * The source of an AngularJS expression.
 */
private newtype TNgSource = MkNgSource(NgSourceProvider p)

/**
 * The source of an AngularJS expression.
 */
class NgSource extends MkNgSource {
  NgSourceProvider provider;

  NgSource() { this = MkNgSource(provider) }

  /**
   * Gets the raw text of this source code.
   */
  string getText() { provider.providesSourceAt(result, _, _, _, _, _) }

  /**
   * Gets the provider for this source code.
   */
  NgSourceProvider getProvider() { result = provider }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getText() }
}

/**
 * Get the regexp that matches the shortest strings wrapped in '{{' and '}}'.
 */
private string getInterpolatedExpressionPattern() { result = "(?<=\\{\\{).*?(?=\\}\\})" }

/**
 * AngularJS expression source from HTML text (e.g. `myExpr` of `<div>Some text {{myExpr}} some text</div>`).
 */
private class HtmlTextNodeAsNgSourceProvider extends NgSourceProvider, HTML::TextNode {
  string source;

  HtmlTextNodeAsNgSourceProvider() {
    source = this.getText().regexpFind(getInterpolatedExpressionPattern(), _, _)
  }

  override predicate providesSourceAt(
    string src, string path, int startLine, int startColumn, int endLine, int endColumn
  ) {
    src = source and
    this.getLocation().hasLocationInfo(path, startLine, startColumn, endLine, endColumn) // this is the entire surrounding text element, we could be more precise by counting lines
  }

  override DOM::ElementDefinition getEnclosingElement() { result = this.getParent() }
}

/**
 * AngularJS expression source from HTML attributes (e.g. `myId` of `<div id="{{myId}}"/>`).
 */
abstract private class HtmlAttributeAsNgSourceProvider extends NgSourceProvider, HTML::Attribute {
  override predicate providesSourceAt(
    string src, string path, int startLine, int startColumn, int endLine, int endColumn
  ) {
    src = this.getSource() and
    this.getLocation().hasLocationInfo(path, startLine, startColumn - this.getOffset(), endLine, _) and
    endColumn = startColumn + src.length() - 1
  }

  /** The source code of the expression. */
  abstract string getSource();

  /** The offset into the attribute where the expression starts. */
  abstract int getOffset();

  override DOM::ElementDefinition getEnclosingElement() { result = this.getElement() }
}

/**
 * AngularJS expression sources interpolated with `{{}}` in attributes.
 */
private class HtmlAttributeAsInterpolatedNgSourceProvider extends HtmlAttributeAsNgSourceProvider {
  string source;
  int offset;

  HtmlAttributeAsInterpolatedNgSourceProvider() {
    source = this.getValue().regexpFind(getInterpolatedExpressionPattern(), _, offset) and
    not this instanceof HtmlAttributeAsPlainNgSourceProvider
  }

  override string getSource() { result = source }

  override int getOffset() { result = offset }
}

/**
 * AngularJS expression sources in attributes.
 */
private class HtmlAttributeAsPlainNgSourceProvider extends HtmlAttributeAsNgSourceProvider {
  HtmlAttributeAsPlainNgSourceProvider() {
    exists(AngularJS::DirectiveInstance d |
      d.getATarget() = this and
      not (
        // builtins that uses interpolation
        d.getName() = "ngHref" or
        d.getName() = "ngSrc" or
        d.getName() = "ngSrcset" or
        // string of the form: `<Ident>( as <Ident>)?`
        d.getName() = "ngController"
      )
    )
  }

  override string getSource() { result = this.getValue() }

  override int getOffset() { result = 0 }
}

/**
 * AngularJS expression sources interpolated with `{{}}` in the `.template` field of an AngularJS directive.
 */
private class TemplateFieldNgSourceProvider extends NgSourceProvider {
  AngularJS::GeneralDirective directive;
  string source;
  int offset;

  TemplateFieldNgSourceProvider() {
    this = directive.getMember("template").asExpr() and
    source =
      this.(ConstantString)
          .getStringValue()
          .regexpFind(getInterpolatedExpressionPattern(), _, offset)
  }

  override predicate providesSourceAt(
    string src, string path, int startLine, int startColumn, int endLine, int endColumn
  ) {
    src = source and
    this.getLocation().hasLocationInfo(path, startLine, startColumn - offset, endLine, _) and
    endColumn = startColumn + src.length() - 1
  }

  override DOM::ElementDefinition getEnclosingElement() { result = directive.getAMatchingElement() }
}

/**
 * A token from a tokenized AngularJS expression source.
 */
abstract class NgToken extends TNgToken {
  // (only exposed for testability)
  /** Holds if this token starts at `start` of NgSource `src`. */
  abstract predicate at(NgSource src, int start);

  /** Gets a textual representation of this element. */
  string toString() {
    exists(string content |
      this.is(content) and
      result = "(" + this.ppKind() + ": " + content + ")"
    )
  }

  /**
   * Pretty prints the kind of this token.
   */
  abstract string ppKind();

  /**
   * Holds if this token has source text content.
   */
  abstract predicate is(string content);

  /**
   * Gets the predecessor of this token.
   */
  NgToken pre() {
    exists(NgSource src |
      this.at(src, _) and
      result.at(src, _)
    ) and
    result.getIndex() + 1 = this.getIndex()
  }

  /**
   * Gets the index of this token in the list of tokens of the enclosing `NgSource`.
   */
  private int getIndex() {
    exists(NgSource src, int start | this.at(src, start) |
      start =
        rank[result + 1](NgToken someToken, int someStart | someToken.at(src, someStart) | someStart)
    )
  }

  /**
   * Gets the successor of this token.
   */
  NgToken succ() { result.pre() = this }
}

/**
 * Provides classes for lexing AngularJS expression source code.
 *
 * See https://github.com/angular/angular.js/blob/master/src/ng/parse.js -> Lexer.prototype
 */
private module Lexer {
  /**
   * Base class for lexer tokens.
   *
   * Lexing is done using `regexpFind` on a disjunction of the result of the `getPattern` methods of all token types.
   * This means that tokens defined by `getPattern` should *not* overlap, otherwise `regexpFind` might start skipping tokens.
   */
  abstract private class NgTokenType extends string {
    bindingset[this]
    NgTokenType() { any() }

    abstract string getPattern();
  }

  private class NgStringTokenType extends NgTokenType {
    NgStringTokenType() { this = "NgStringTokenType" }

    override string getPattern() { result = "'(?:\\\\'|[^'])*'|\"(?:\\\\\"|[^\"])*\"" }
  }

  private class NgWhitespaceTokenType extends NgTokenType {
    NgWhitespaceTokenType() { this = "NgWhitespaceTokenType" }

    override string getPattern() { result = "\\s+" }
  }

  private class NgIdentTokenType extends NgTokenType {
    NgIdentTokenType() { this = "NgIdentTokenType" }

    override string getPattern() { result = "[A-Za-z$_][\\w$]*" }
  }

  private class NgNumberTokenType extends NgTokenType {
    NgNumberTokenType() { this = "NgNumberTokenType" }

    override string getPattern() { result = "\\d+(\\.\\d*)?" }
  }

  private class NgOtherTokenType extends NgTokenType {
    NgOtherTokenType() { this = "NgOtherTokenType" }

    override string getPattern() { result = "[(){}\\[\\].,;:?]" }
  }

  private class NgOpTokenType extends NgTokenType {
    NgOpTokenType() { this = "NgOpTokenType" }

    override string getPattern() {
      result =
        concat(string op |
          op =
            [
              "===", "!==", "==", "!=", "<=", ">=", "&&", "||", "*", "!", "=", "<", ">", "+", "-",
              "/", "%", "|"
            ]
        |
          "\\Q" + op + "\\E", "|" order by op.length() desc
        )
    }
  }

  newtype TNgToken =
    MkNgToken(NgSource src, int start, NgTokenType tp, string text) {
      exists(string allTokenTypePattern |
        allTokenTypePattern = concat(NgTokenType t, string p | p = t.getPattern() | p, "|") and
        text = src.getText().regexpFind(allTokenTypePattern, _, start) and
        text.regexpMatch(tp.getPattern())
      )
    }

  abstract private class NgInternalToken extends TNgToken, NgToken {
    override predicate at(NgSource src, int start) { this = MkNgToken(src, start, _, _) }

    override string ppKind() {
      exists(string s, string type |
        this = MkNgToken(_, _, type, _) and
        type = "Ng" + s + "TokenType" and
        result = s.toUpperCase()
      )
    }

    override predicate is(string content) { this = MkNgToken(_, _, _, content) }
  }

  /**
   * A string token.
   */
  class NgStringToken extends NgInternalToken {
    NgStringToken() { this = MkNgToken(_, _, any(NgStringTokenType t), _) }
  }

  /**
   * A number token.
   */
  class NgNumToken extends NgInternalToken {
    NgNumToken() { this = MkNgToken(_, _, any(NgNumberTokenType t), _) }
  }

  /**
   * An identifier token.
   */
  class NgIdentToken extends NgInternalToken {
    NgIdentToken() { this = MkNgToken(_, _, any(NgIdentTokenType t), _) }
  }

  /**
   * An "other" token.
   */
  class NgOtherToken extends NgInternalToken {
    NgOtherToken() { this = MkNgToken(_, _, any(NgOtherTokenType t), _) }
  }

  /**
   * An operator token.
   */
  class NgOpToken extends NgInternalToken {
    NgOpToken() { this = MkNgToken(_, _, any(NgOpTokenType t), _) }
  }
}

private import Lexer

/**
 * An NgAst node from a parsed AngularJS expression source.
 */
abstract class NgAstNode extends TNode {
  /**
   * Holds if the node spans the tokens from `start` to `end` (inclusive).
   */
  abstract predicate at(NgToken start, NgToken end);

  /**
   * Gets the `n`th child node.
   */
  abstract NgAstNode getChild(int n);

  /**
   * Pretty prints the child nodes.
   */
  language[monotonicAggregates]
  string ppChildren() {
    result =
      concat(NgAstNode child, int idx |
        child = this.getChild(idx) and
        not child instanceof Empty
      |
        child.pp(), " " order by idx
      )
  }

  /** Gets a textual representation of this element. */
  string toString() { result = this.pp() }

  /**
   * Pretty-prints this node.
   */
  abstract string pp();
}

/**
 * The root node of an abstract syntax tree.
 */
class NgAst extends TNgAst, NgAstNode {
  override predicate at(NgToken start, NgToken end) { this = TNgAst(start, end, _, _) }

  override string pp() {
    exists(string oneTime |
      (if this.isOneTime() then oneTime = " <oneTime>" else oneTime = "") and
      result = "(NgAst:" + oneTime + " " + this.ppChildren() + ")"
    )
  }

  override NgAstNode getChild(int n) { n = 0 and this = TNgAst(_, _, _, result) }

  /**
   * Holds if this is a "one time binding" (i.e. ::-prefixed, e.g. `{{::myId}}`).
   */
  predicate isOneTime() { this = TNgAst(_, _, true, _) }
}

/**
 * An expression-statement node.
 */
class NgExprStmt extends TNgExprStmt, NgAstNode {
  override predicate at(NgToken start, NgToken end) { this = TNgExprStmt(start, end, _) }

  override string pp() { result = "(NgExprStmt: " + this.ppChildren() + ")" }

  override NgAstNode getChild(int n) { n = 0 and this = TNgExprStmt(_, _, result) }
}

/**
 * A "filter-chain" node (see https://github.com/angular/angular.js/blob/master/src/ng/parse.js -> filterChain).
 *
 * Example: `expr | filter1 | filter2 | ...`, the filters are optional (i.e. `Empty`).
 */
class NgFilterChain extends TNgFilterChain, NgAstNode {
  override predicate at(NgToken start, NgToken end) { this = TNgFilterChain(start, end, _, _) }

  override string pp() { result = "(NgFilterChain: " + this.ppChildren() + ")" }

  override NgAstNode getChild(int n) {
    n = 0 and result = this.getExpr()
    or
    n = 1 and result = this.getFilter()
  }

  /**
   * Gets the leading expression of this filter chain.
   */
  NgExpr getExpr() { this = TNgFilterChain(_, _, result, _) }

  /**
   * Gets the filter of this filter chain.
   */
  NgFilter getFilter() { this = TNgFilterChain(_, _, _, result) }
}

/**
 * Super class for `NgFilter` and `Empty`.
 */
abstract class NgMaybeFilter extends NgAstNode { }

/**
 * A filter node.
 *
 * Example: `filter1 ... | filter2`
 */
class NgFilter extends TNgFilter, NgMaybeFilter {
  override predicate at(NgToken start, NgToken end) { this = TNgFilter(start, end, _, _) }

  override string pp() { result = "(NgFilter: " + this.ppChildren() + ")" }

  override NgAstNode getChild(int n) {
    n = 0 and result = this.getHeadFilter()
    or
    n = 1 and result = this.getTailFilter()
  }

  /**
   * Gets the successor filter of this filter, if any.
   */
  NgSingleFilter getHeadFilter() { this = TNgFilter(_, _, result, _) }

  /**
   * Gets the tail filter of this filter, if any.
   */
  NgFilter getTailFilter() { this = TNgFilter(_, _, _, result) }
}

/**
 * A single filter node.
 *
 * Example: `filter1:arg1:arg2`
 */
class NgSingleFilter extends TNgSingleFilter, NgAstNode {
  override predicate at(NgToken start, NgToken end) { this = TNgSingleFilter(start, end, _, _) }

  override string pp() {
    exists(string sep |
      (
        if forall(NgAstNode child | child = this.getChild(_) | child instanceof Empty)
        then sep = ""
        else sep = " "
      ) and
      result = "(NgSingleFilter: " + this.getName() + sep + this.ppChildren() + ")"
    )
  }

  override NgAstNode getChild(int n) { n = 0 and this = TNgSingleFilter(_, _, _, result) }

  /**
   * Gets the name of the referenced filter.
   */
  string getName() { this = TNgSingleFilter(_, _, result, _) }

  /**
   * Gets the `i`th argument expression of this filter call.
   */
  NgExpr getArgument(int i) { result = this.getChild(0).(NgFilterArgument).getElement(i) }
}

/**
 * An expression node.
 */
abstract class NgExpr extends NgAstNode { }

/**
 * A variable reference expression node.
 */
class NgVarExpr extends TNgVarExpr, NgExpr {
  NgIdentToken identifier;

  NgVarExpr() { this = TNgVarExpr(identifier) }

  override predicate at(NgToken start, NgToken end) { start = end and start = identifier }

  override string pp() { result = "(NgVarExpr: " + this.getName() + ")" }

  override NgAstNode getChild(int n) { none() }

  /**
   * Gets the name of the referenced variable.
   */
  string getName() { identifier.is(result) }
}

/**
 * A dot expression node for looking up a fixed property with a fixed name.
 */
class NgDotExpr extends TNgDotExpr, NgExpr {
  override predicate at(NgToken start, NgToken end) { this = TNgDotExpr(start, end, _, _) }

  override string pp() {
    result = "(NgDotExpr: " + this.getBase().pp() + "." + this.getName() + ")"
  }

  override NgAstNode getChild(int n) { n = 0 and result = this.getBase() }

  /**
   * Gets the node for the base expression of this expression.
   */
  NgAstNode getBase() { this = TNgDotExpr(_, _, result, _) }

  /**
   * Gets the name of the property that is looked up.
   */
  string getName() { this = TNgDotExpr(_, _, _, result) }
}

/**
 * A call expression node.
 */
class NgCallExpr extends TNgCallExpr, NgExpr {
  override predicate at(NgToken start, NgToken end) { this = TNgCallExpr(start, end, _, _) }

  override string pp() { result = "(NgCallExpr: " + this.ppChildren() + ")" }

  override NgAstNode getChild(int n) {
    n = 0 and this = TNgCallExpr(_, _, result, _)
    or
    n = 1 and this = TNgCallExpr(_, _, _, result)
  }

  /**
   * Gets the callee expression of this call.
   */
  NgExpr getCallee() { result = this.getChild(0) }

  /**
   * Gets the `i`th argument expression of this call.
   */
  NgExpr getArgument(int i) { result = this.getChild(1).(NgConsCallArgument).getElement(i) }
}

/**
 * A string expression node.
 */
class NgString extends TNgString, NgExpr {
  NgStringToken stringToken;

  NgString() { this = TNgString(stringToken) }

  override predicate at(NgToken start, NgToken end) { start = end and start = stringToken }

  override string pp() { result = this.getRawValue() }

  override NgAstNode getChild(int n) { none() }

  /**
   * Gets the raw string value of this expression, including surrounding quotes.
   */
  string getRawValue() { stringToken.is(result) }

  /**
   * Gets the string value of this expression, excluding surrounding quotes.
   */
  string getStringValue() {
    result = this.getRawValue().substring(1, this.getRawValue().length() - 1)
  }
}

/**
 * A number expression node.
 */
class NgNumber extends TNgNumber, NgExpr {
  NgNumToken numberToken;

  NgNumber() { this = TNgNumber(numberToken) }

  override predicate at(NgToken start, NgToken end) { start = end and start = numberToken }

  override string pp() { result = this.getValue() }

  override NgAstNode getChild(int n) { none() }

  /**
   * Gets the number value of this expression.
   */
  string getValue() { numberToken.is(result) }
}

/**
 * Super class for `NgFilterArgument` and `Empty`.
 */
abstract class NgMaybeFilterArgument extends NgAstNode { }

/**
 * A non-empty cons-list of arguments for a filter.
 */
class NgFilterArgument extends TNgFilterArgument, NgMaybeFilterArgument {
  override predicate at(NgToken start, NgToken end) { this = TNgFilterArgument(start, end, _, _) }

  override string pp() { result = "(NgFilterArgument: " + this.ppChildren() + ")" }

  override NgAstNode getChild(int n) {
    n = 0 and this = TNgFilterArgument(_, _, result, _)
    or
    n = 1 and this = TNgFilterArgument(_, _, _, result)
  }

  /**
   * Gets the `i`th element of this entire cons-list.
   */
  NgExpr getElement(int i) {
    if i = 0
    then result = this.getChild(0)
    else result = this.getChild(1).(NgFilterArgument).getElement(i - 1)
  }
}

/**
 * Super class for `NgConsCallArgument` and `Empty`.
 */
abstract class NgCallArguments extends NgAstNode { }

/**
 * A non-empty cons-list of arguments for a call.
 */
class NgConsCallArgument extends TNgConsCallArgument, NgCallArguments {
  override predicate at(NgToken start, NgToken end) { this = TNgConsCallArgument(start, end, _, _) }

  override string pp() { result = "(NgConsCallArgument: " + this.ppChildren() + ")" }

  override NgAstNode getChild(int n) {
    n = 0 and this = TNgConsCallArgument(_, _, result, _)
    or
    n = 1 and this = TNgConsCallArgument(_, _, _, result)
  }

  /**
   * Gets the `i`th element of this entire cons-list.
   */
  NgExpr getElement(int i) {
    if i = 0
    then result = this.getChild(0)
    else result = this.getChild(1).(NgConsCallArgument).getElement(i - 1)
  }
}

/**
 * The empty alternative of maybes.
 */
class Empty extends TNgEmpty, NgMaybeFilter, NgMaybeFilterArgument, NgCallArguments {
  override predicate at(NgToken start, NgToken end) { start = end and this = TNgEmpty() }

  override string pp() { result = "<Empty>" }

  override NgAstNode getChild(int n) { none() }
}

private module Parser {
  /**
   * Parses a `NgFilter` or `Empty`, whichever is possible.
   */
  private NgMaybeFilter maybeFilter(NgToken start, NgToken end) {
    if start.succ().(NgOpToken).is("|")
    then result.(NgFilter).at(start.succ().succ(), end)
    else result.(Empty).at(start, end)
  }

  /**
   * Parses a `NgFilterArgument` or `Empty`, whichever is possible.
   */
  private NgMaybeFilterArgument maybeFilterArgument(NgToken start, NgToken end) {
    if start.succ().(NgOtherToken).is(":")
    then result.(NgFilterArgument).at(start.succ().succ(), end)
    else result.(Empty).at(start, end)
  }

  /**
   * Parses a the first `NgConsCallArgument` of a call or `Empty`, whichever is possible.
   */
  private NgCallArguments maybeFirstCallArgument(NgToken start, NgToken end) {
    if start.succ().(NgOtherToken).is(")")
    then result.(Empty).at(start, end)
    else result.(NgConsCallArgument).at(start.succ(), end)
  }

  /**
   * Parses a the second or later `NgConsCallArgument` of a call or `Empty`, whichever is possible.
   */
  private NgCallArguments maybeCallArgument(NgToken start, NgToken end) {
    if start.succ().(NgOtherToken).is(",")
    then result.(NgConsCallArgument).at(start.succ().succ(), end)
    else result.(Empty).at(start, end)
  }

  /**
   * NgAst node types. Associated with a range of tokens.
   */
  cached
  newtype TNode =
    TNgAst(NgToken start, NgToken end, boolean oneTime, NgExprStmt stmt) {
      not exists(start.pre()) and
      not exists(end.succ()) and
      exists(NgToken stmtStart |
        if start.(NgOtherToken).is(":") and start.succ().(NgOtherToken).is(":")
        then (
          stmtStart = start.succ().succ() and oneTime = true
        ) else (
          stmtStart = start and oneTime = false
        )
      |
        stmt.at(stmtStart, end)
      )
    } or
    TNgExprStmt(NgToken start, NgToken end, NgFilterChain c) { c.at(start, end) } or
    TNgFilterChain(NgToken start, NgToken end, NgExpr e, NgMaybeFilter f) {
      exists(NgToken mid |
        e.at(start, mid) and
        f = maybeFilter(mid, end)
      )
    } or
    TNgSingleFilter(NgToken start, NgToken end, string name, NgMaybeFilterArgument a) {
      start.(NgIdentToken).is(name) and
      a = maybeFilterArgument(start, end)
    } or
    TNgFilter(NgToken start, NgToken end, NgSingleFilter head, NgMaybeFilter tail) {
      exists(NgToken endArgs |
        head.at(start, endArgs) and
        tail = maybeFilter(endArgs, end)
      )
    } or
    TNgFilterArgument(NgToken start, NgToken end, NgExpr base, NgMaybeFilterArgument a) {
      exists(NgToken mid |
        base.at(start, mid) and
        a = maybeFilterArgument(mid, end)
      )
    } or
    TNgDotExpr(NgToken start, NgIdentToken end, NgExpr base, string name) {
      base.at(start, end.pre().pre()) and
      end.pre().(NgOtherToken).is(".") and
      end.is(name)
    } or
    TNgCallExpr(NgToken start, NgOtherToken end, NgExpr base, NgCallArguments a) {
      exists(NgToken endBase |
        base.at(start, endBase) and
        endBase.succ().(NgOtherToken).is("(") and
        a = maybeFirstCallArgument(endBase.succ(), end.pre()) and
        end.is(")")
      )
    } or
    TNgConsCallArgument(NgToken start, NgToken end, NgExpr e, NgCallArguments a) {
      exists(NgToken mid |
        e.at(start, mid) and
        a = maybeCallArgument(mid, end)
      )
    } or
    TNgVarExpr(NgIdentToken t) or
    TNgString(NgStringToken t) or
    TNgNumber(NgNumToken t) or
    TNgEmpty()
}

private import Parser

/**
 * A node in an AngularJS expression that can have dataflow.
 *
 * Will eventually be a subtype of `DataFlow::Node`.
 */
class NgDataFlowNode extends TNode {
  NgAstNode astNode;

  NgDataFlowNode() { this = astNode }

  /** Gets the AST node this node corresponds to. */
  NgAstNode getAstNode() { result = astNode }

  /** Gets a textual representation of this element. */
  string toString() { result = astNode.toString() }

  /**
   * Gets a scope object for this node.
   */
  AngularJS::AngularScope getAScope() {
    exists(NgToken token, NgSource source |
      astNode.at(token, _) and
      token.at(source, _)
    |
      result.mayApplyTo(source.getProvider().getEnclosingElement())
    )
  }
}

/** Holds if everything in the given file should be considered part of an AngularJS app. */
private predicate fileIsImplicitlyAngularJS(HTML::HtmlFile file) {
  // The file contains ng-* attributes.
  exists(HTML::Attribute attrib |
    attrib.getName().matches("ng-%") and
    attrib.getFile() = file
  ) and
  // But does not contain the ng-app root element, implying that file is
  // included from elsewhere.
  not exists(HTML::Attribute attrib |
    attrib.getName() = "ng-app" and
    attrib.getFile() = file
  )
}

/** Holds if `element` is under a `ng-non-bindable` directive, disabling interpretation by AngularJS. */
private predicate isNonBindable(HTML::Element element) {
  exists(element.getParent*().getAttributeByName("ng-non-bindable"))
}

/**
 * Holds if the contents and attribute values of the given element are interpreted by AngularJS,
 * that is, any placeholder expressions therein, such as `{{x}}`, are evaluated and inserted in the output.
 */
predicate isInterpretedByAngularJS(HTML::Element element) {
  (
    fileIsImplicitlyAngularJS(element.getFile())
    or
    exists(element.getParent*().getAttributeByName("ng-app"))
  ) and
  not isNonBindable(element) and
  not element.getName() = "script" // script tags are never interpreted
}
