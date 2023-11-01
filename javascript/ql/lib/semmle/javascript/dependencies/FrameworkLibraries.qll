/**
 * Provides classes for identifying popular framework libraries.
 *
 * Each framework is identified by a subclass of `FrameworkLibrary`,
 * which is simply a tag identifying the library, such as `"jquery"`.
 * This represents the framework as an abstract concept.
 *
 * Subclasses of `FrameworkLibraryInstance` identify concrete instances
 * (or copies) of frameworks, that is, files (or scripts embedded in
 * HTML) containing the implementation of a particular version of
 * a framework library.
 *
 * Subclasses of `FrameworkLibraryReference` identify HTML `<script>`
 * tags that refer to a particular version of a framework library.
 *
 * Typically, framework library instances are identified by looking
 * for marker comments, while framework library references are
 * identified by analyzing the URL referenced in the `src` attribute.
 *
 * Common patterns for doing this are encapsulated by classes
 * `FrameworkLibraryWithMarkerComment` and `FrameworkLibraryWithGenericURL`,
 * which identify framework libraries by matching their marker comment and
 * URL, respectively, against a regular expression. Most frameworks can
 * be represented by a single class extending both of these two classes
 * (for example `Bootstrap` and `React`), while other frameworks have
 * more complex rules for recognizing instances (for example `MooTools`).
 */

import javascript

/**
 * An abstract representation of a framework library.
 */
abstract class FrameworkLibrary extends string {
  bindingset[this]
  FrameworkLibrary() { this = this }

  /**
   * Gets the unique identifier of this framework library.
   *
   * By default, this is simply the name of the framework,
   * but it should be treated as an opaque value.
   */
  string getId() { result = this }

  /**
   * Gets the name of a global variable or of a property of a global
   * variable that serves as an API entry point for this framework
   * library.
   *
   * For example, jQuery has two entry points `$` and `jQuery`,
   * while jQuery Mobile has an entry point `$.mobile`.
   *
   * Subclasses do not have to override this predicate, but dependency
   * counts for frameworks without known API entry points are less
   * precise.
   */
  string getAnEntryPoint() { none() }
}

/**
 * An instance (or copy) of a framework library, that is,
 * a file or script containing the code for a particular
 * version of a framework.
 */
abstract class FrameworkLibraryInstance extends TopLevel {
  /**
   * Holds if this is an instance of version `v` of framework library `fl`.
   */
  abstract predicate info(FrameworkLibrary fl, string v);
}

/**
 * An abstract representation of a reference to a framework library
 * via the `src` attribute of a `<script>` element.
 */
abstract class FrameworkLibraryReference extends HTML::Attribute {
  FrameworkLibraryReference() {
    this.getName() = "src" and this.getElement() instanceof HTML::ScriptElement
  }

  /**
   * Holds if this is a reference to version `v` of framework library `fl`.
   */
  abstract predicate info(FrameworkLibrary fl, string v);
}

/**
 * A framework library whose instances can be identified by marker comments.
 */
abstract class FrameworkLibraryWithMarkerComment extends FrameworkLibrary {
  bindingset[this]
  FrameworkLibraryWithMarkerComment() { this = this }

  /**
   * Gets a regular expression that can be used to identify an instance of
   * this framework library, with `<VERSION>` as a placeholder for version
   * numbers.
   *
   * The first capture group of this regular expression should match
   * the version number.
   *
   * Subclasses should implement this predicate.
   *
   * Callers should avoid using this predicate directly,
   * and instead use `getAMarkerCommentRegexWithoutPlaceholders()`,
   * which will replace any occurrences of the string `<VERSION>` in
   * the regular expression with `versionRegex()`.
   */
  abstract string getAMarkerCommentRegex();

  /**
   * Gets a regular expression that can be used to identify an instance of
   * this framework library.
   *
   * The first capture group of this regular expression is intended to match
   * the version number.
   */
  final string getAMarkerCommentRegexWithoutPlaceholders() {
    result = this.getAMarkerCommentRegex().replaceAll("<VERSION>", versionRegex())
  }
}

/**
 * A framework library that is referenced by URLs that have a certain
 * pattern.
 */
abstract class FrameworkLibraryWithUrlRegex extends FrameworkLibrary {
  bindingset[this]
  FrameworkLibraryWithUrlRegex() { this = this }

  /**
   * Gets a regular expression that can be used to identify a URL referring
   * to this framework library.
   *
   * The first capture group of this regular expression should match
   * the version number.
   */
  abstract string getAUrlRegex();
}

/**
 * A framework library that is referenced by URLs containing the name
 * of the framework (or an alias) and a version string.
 *
 * We currently recognize two kinds of URLs:
 *
 *   * URLs whose last component is `<framework id>-<version>.js`,
 *     possibly with some variant suffixes before the `.js`;
 *   * URLs of the form `.../<version>/<framework id>.js`,
 *     again possibly with suffixes before the `.js`; additionally,
 *     we allow a path component between `<version>` and `<framework id>`
 *     that repeats `<framework id>`, or is one of `dist` and `js`.
 *
 * See `variantRegex()` below for a discussion of variant suffixes.
 */
abstract class FrameworkLibraryWithGenericUrl extends FrameworkLibraryWithUrlRegex {
  bindingset[this]
  FrameworkLibraryWithGenericUrl() { this = this }

  /** Gets an alternative name of this library. */
  string getAnAlias() { none() }

  override string getAUrlRegex() {
    exists(string id | id = this.getId() or id = this.getAnAlias() |
      result = ".*(?:^|/)" + id + "-(" + semverRegex() + ")" + variantRegex() + "\\.js" or
      result =
        ".*/(?:\\w+@)?(" + semverRegex() + ")/(?:(?:dist|js|" + id + ")/)?" + id + variantRegex() +
          "\\.js"
    )
  }
}

/**
 * Gets a regular expression identifying suffixes that are commonly appended
 * to the name of a library to distinguish minor variants.
 *
 * We ignore these when identifying frameworks.
 */
private string variantRegex() {
  result =
    "([.-](slim|min|debug|dbg|umd|dev|all|testing|polyfills|" +
      "core|compat|more|modern|sandbox|rtl|with-addons|legacy))*"
}

/**
 * Gets a regular expression identifying version numbers in URLs.
 *
 * We currently recognize version numbers of the form
 * `<major>.<minor>.<patch>-beta.<n>`, where `.<patch>` and/or
 * `-beta.<n>` may be missing.
 */
private string semverRegex() { result = "\\d+\\.\\d+(?:\\.\\d+)?(?:-beta\\.\\d+)?" }

/**
 * An instance of a `FrameworkLibraryWithMarkerComment`.
 */
class FrameworkLibraryInstanceWithMarkerComment extends FrameworkLibraryInstance {
  FrameworkLibraryInstanceWithMarkerComment() { matchMarkerComment(_, this, _, _) }

  override predicate info(FrameworkLibrary fl, string v) { matchMarkerComment(_, this, fl, v) }
}

/** A marker comment that indicates a framework library. */
private class MarkerComment extends Comment {
  MarkerComment() {
    /*
     * PERFORMANCE OPTIMISATION:
     *
     * Each framework library has a regular expression describing its marker comments.
     * We want to find the set of marker comments and the framework regexes they match.
     * In order to perform such regex matching, CodeQL needs to compute the
     * Cartesian product of possible receiver strings and regexes first,
     * containing `num_receivers * num_regexes` tuples.
     *
     * A straightforward attempt to match marker comments with individual
     * framework regexes will compute the Cartesian product between
     * the set of comments and the set of framework regexes.
     * Total: `num_comments * num_frameworks` tuples.
     *
     * Instead, create a single regex that matches *all* frameworks.
     * This is the regex union of the individual framework regexes
     * i.e. `(regex_1)|(regex_2)|...|(regex_n)`
     * This approach will compute the Cartesian product between
     * the set of comments and the singleton set of this union regex.
     * Total: `num_comments * 1` tuples.
     *
     * To identify the individual frameworks and extract the version number from capture groups,
     * use the member predicate `matchesFramework` *after* this predicate has been computed.
     */

    exists(string unionRegex |
      unionRegex =
        concat(FrameworkLibraryWithMarkerComment fl |
          |
          "(" + fl.getAMarkerCommentRegexWithoutPlaceholders() + ")", "|"
        )
    |
      this.getText().regexpMatch(unionRegex)
    )
  }

  /**
   * Holds if this marker comment indicates an instance of the framework `fl`
   * with version number `version`.
   */
  predicate matchesFramework(FrameworkLibraryWithMarkerComment fl, string version) {
    this.getText().regexpCapture(fl.getAMarkerCommentRegexWithoutPlaceholders(), 1) = version
  }
}

/**
 * Holds if comment `c` in toplevel `tl` matches the marker comment of library
 * `fl` at `version`.
 */
cached
private predicate matchMarkerComment(
  MarkerComment c, TopLevel tl, FrameworkLibraryWithMarkerComment fl, string version
) {
  c.getTopLevel() = tl and
  c.matchesFramework(fl, version)
}

/**
 * A reference to a `FrameworkLibraryWithURL`.
 */
class FrameworkLibraryReferenceWithUrl extends FrameworkLibraryReference {
  FrameworkLibraryReferenceWithUrl() { matchUrl(this, _, _) }

  override predicate info(FrameworkLibrary fl, string v) { matchUrl(this, fl, v) }
}

/**
 * Holds if the value of `src` attribute `attr` matches the URL pattern of library
 * `fl` at `version`.
 */
private predicate matchUrl(HTML::Attribute attr, FrameworkLibraryWithUrlRegex fl, string version) {
  attr.getName() = "src" and
  attr.getElement() instanceof HTML::ScriptElement and
  version = attr.getValue().regexpCapture(fl.getAUrlRegex(), 1)
}

/**
 * Gets a regular expression for matching versions specified in marker comments.
 */
private string versionRegex() { result = "\\d+\\.\\d+[A-Za-z0-9.+_-]*" }

/**
 * The jQuery framework.
 */
private class JQuery extends FrameworkLibraryWithGenericUrl {
  JQuery() { this = "jquery" }

  override string getAnEntryPoint() { result = "$" or result = "jQuery" }
}

/**
 * Holds if comment `c` in toplevel `tl` is a marker comment for the given `version`
 * of jQuery.
 */
private predicate jQueryMarkerComment(Comment c, TopLevel tl, string version) {
  tl = c.getTopLevel() and
  exists(string txt | txt = c.getText() |
    // More recent versions use this format:
    // "(?s).*jQuery (?:JavaScript Library )?v(" + versionRegex() + ").*",
    // Earlier versions used this format:
    // "(?s).*jQuery (" + versionRegex() + ") - New Wave Javascript.*"
    // For efficiency, construct a single regex that matches both,
    // at the cost of being slightly more permissive.
    version =
      txt.regexpCapture("(?s).*jQuery (?:JavaScript Library )?v?(" + versionRegex() +
          ")(?: - New Wave Javascript)?.*", 1)
    or
    // 1.0.0 and 1.0.1 have the same marker comment; we call them both "1.0"
    txt.matches("%jQuery - New Wave Javascript%") and version = "1.0"
  )
}

/**
 * A copy of jQuery.
 */
private class JQueryInstance extends FrameworkLibraryInstance {
  JQueryInstance() { jQueryMarkerComment(_, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof JQuery and
    jQueryMarkerComment(_, this, v)
  }
}

/**
 * The jQuery Mobile framework.
 */
private class JQueryMobile extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment
{
  JQueryMobile() { this = "jquery-mobile" }

  override string getAnAlias() { result = "jquery.mobile" }

  override string getAMarkerCommentRegex() { result = "(?s).*jQuery Mobile (<VERSION>).*" }

  override string getAnEntryPoint() { result = "$.mobile" or result = "jQuery.mobile" }
}

/**
 * The jQuery UI framework.
 */
private class JQueryUI extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  JQueryUI() { this = "jquery-ui" }

  override string getAMarkerCommentRegex() { result = "(?s).*jQuery UI - v?(<VERSION>).*" }

  override string getAnEntryPoint() { result = "$.ui" or result = "jQuery.ui" }
}

/**
 * The jQuery TextExt framework.
 */
private class JQueryTextExt extends FrameworkLibraryWithGenericUrl,
  FrameworkLibraryWithMarkerComment
{
  JQueryTextExt() { this = "jquery-textext" }

  override string getAnAlias() { result = "jquery.textext" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*jQuery TextExt Plugin.*@version (<VERSION>).*"
  }

  override string getAnEntryPoint() { result = "$.text" or result = "jQuery.text" }
}

/**
 * The jQuery DataTables framework.
 */
private class JQueryDataTables extends FrameworkLibraryWithGenericUrl,
  FrameworkLibraryWithMarkerComment
{
  JQueryDataTables() { this = "jquery-dataTables" }

  override string getAnAlias() { result = "jquery.dataTables" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*@version\\s+(<VERSION>).*@file\\s+jquery\\.dataTables\\.js.*"
  }
}

/**
 * The jQuery jsTree framework.
 */
private class JQueryJsTree extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment
{
  JQueryJsTree() { this = "jquery-jstree" }

  override string getAnAlias() { result = "jquery.jstree" }

  override string getAMarkerCommentRegex() { result = "(?s).*jsTree (<VERSION>).*" }
}

/**
 * The jQuery Snippet framework.
 */
private class JQuerySnippet extends FrameworkLibraryWithGenericUrl,
  FrameworkLibraryWithMarkerComment
{
  JQuerySnippet() { this = "jquery-snippet" }

  override string getAnAlias() { result = "jquery.snippet" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*Snippet :: jQuery Syntax Highlighter v(<VERSION>).*"
  }
}

/**
 * The Bootstrap framework.
 */
private class Bootstrap extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  Bootstrap() { this = "bootstrap" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*Bootstrap v(<VERSION>) \\(http://getbootstrap.com\\).*"
  }

  override string getAnEntryPoint() { result = "$" }
}

/**
 * The Modernizr framework.
 */
private class Modernizr extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  Modernizr() { this = "modernizr" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*(?<!@license )Modernizr (?:JavaScript library )?v?(<VERSION>).*"
  }

  override string getAnEntryPoint() { result = "Modernizr" }
}

/**
 * The MooTools framework.
 */
private class MooTools extends FrameworkLibraryWithGenericUrl {
  MooTools() { this = "mootools" }

  override string getAnEntryPoint() { /* not easily detectable */ none() }
}

/**
 * Holds if expression `oe` in toplevel `tl` is a meta-information object for
 * MooTools at the given `version`.
 *
 * MooTools puts an object into `this.MooTools` that contains version information;
 * this helper predicate identifies the definition of that object, which is always
 * of the form
 *
 * ```javascript
 * this.MooTools = { version: "<version>", ... }
 * ```
 */
private predicate mooToolsObject(ObjectExpr oe, TopLevel tl, string version) {
  exists(AssignExpr assgn, DotExpr d |
    tl = oe.getTopLevel() and assgn.getLhs() = d and assgn.getRhs() = oe
  |
    d.getBase() instanceof ThisExpr and
    d.getPropertyName() = "MooTools" and
    version = oe.getPropertyByName("version").getInit().getStringValue()
  )
}

/**
 * A copy of MooTools.
 */
private class MooToolsInstance extends FrameworkLibraryInstance {
  MooToolsInstance() { mooToolsObject(_, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof MooTools and
    mooToolsObject(_, this, v)
  }
}

/**
 * The Prototype framework.
 */
private class Prototype extends FrameworkLibraryWithGenericUrl {
  Prototype() { this = "prototype" }

  override string getAnEntryPoint() { /* not easily detectable */ none() }
}

/**
 * Holds if expression `oe` in toplevel `tl` is a meta-information object for
 * Prototype at the given `version`.
 *
 * Prototype declares a variable `Prototype` containing an object with version information;
 * this helper predicates identifies the definition of that object, which is always of the form
 *
 * ```javascript
 * var Prototype = { Version: '<version>', ... }
 * ```
 */
private predicate prototypeObject(ObjectExpr oe, TopLevel tl, string version) {
  exists(VariableDeclarator vd | tl = vd.getTopLevel() and oe = vd.getInit() |
    vd.getBindingPattern().(Identifier).getName() = "Prototype" and
    version = oe.getPropertyByName("Version").getInit().getStringValue()
  )
}

/**
 * A copy of Prototype.
 */
private class PrototypeInstance extends FrameworkLibraryInstance {
  PrototypeInstance() { prototypeObject(_, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof Prototype and
    prototypeObject(_, this, v)
  }
}

/**
 * The Scriptaculous framework.
 */
private class Scriptaculous extends FrameworkLibraryWithGenericUrl {
  Scriptaculous() { this = "scriptaculous" }

  override string getAnEntryPoint() { /* not easily detectable */ none() }
}

/**
 * Holds if expression `oe` in toplevel `tl` is a meta-information object for
 * Scriptaculous at the given `version`.
 *
 * Scriptaculous declares a variable `Scriptaculous` containing an object with version information;
 * this helper predicates identifies the definition of that object, which is always of the form
 *
 * ```javascript
 * var Scriptaculous = { Version: '<version>', ... }
 * ```
 */
private predicate scriptaculousObject(ObjectExpr oe, TopLevel tl, string version) {
  exists(VariableDeclarator vd | tl = vd.getTopLevel() and oe = vd.getInit() |
    vd.getBindingPattern().(Identifier).getName() = "Scriptaculous" and
    version = oe.getPropertyByName("Version").getInit().getStringValue()
  )
}

/**
 * A copy of Scriptaculous.
 */
private class ScriptaculousInstance extends FrameworkLibraryInstance {
  ScriptaculousInstance() { scriptaculousObject(_, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof Scriptaculous and
    scriptaculousObject(_, this, v)
  }
}

/**
 * The Underscore framework.
 */
private class Underscore extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  Underscore() { this = "underscore" }

  override string getAMarkerCommentRegex() { result = "^\\s*Underscore.js (<VERSION>).*" }

  override string getAnEntryPoint() { result = "_" }
}

/**
 * The Lodash framework.
 */
private class Lodash extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  Lodash() { this = "lodash" }

  override string getAMarkerCommentRegex() {
    result =
      "(?s).* (?:lod|Lo-D)ash (<VERSION>)" + "(?: \\(Custom Build\\))? " +
        "<https?://lodash.com/>.*"
  }

  override string getAnEntryPoint() { result = "_" }
}

/** The Dojo framework. */
private class Dojo extends FrameworkLibraryWithGenericUrl {
  Dojo() { this = "dojo" }

  override string getAnEntryPoint() { result = "dojo" }
}

/**
 * Holds if comment `c` in toplevel `tl` is a marker comment for the given
 * `version` of Dojo.
 */
private predicate dojoMarkerComment(Comment c, TopLevel tl, string version) {
  tl = c.getTopLevel() and
  c.getText().regexpMatch("(?s).*Copyright \\(c\\) 2004-20.., The Dojo Foundation.*") and
  // Dojo doesn't embed a version string
  version = "unknown"
}

/**
 * A copy of Dojo.
 */
private class DojoInstance extends FrameworkLibraryInstance {
  DojoInstance() { dojoMarkerComment(_, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof Dojo and
    dojoMarkerComment(_, this, v)
  }
}

/**
 * The ExtJS framework.
 */
private class ExtJS extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  ExtJS() { this = "extjs" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*This file is part of Ext JS (<VERSION>).*" or
    result = "(?s).*Ext Core Library (<VERSION>).*"
  }

  override string getAnAlias() { result = "ext" }

  override string getAnEntryPoint() { result = "Ext" }
}

/**
 * The YUI framework.
 */
private class YUI extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  YUI() { this = "yui" }

  override string getAMarkerCommentRegex() { result = "(?s).*YUI (<VERSION>) \\(build \\d+\\).*" }

  override string getAnEntryPoint() { result = "YUI" }
}

/**
 * The Knockout framework.
 */
private class Knockout extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  Knockout() { this = "knockout" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*Knockout JavaScript library v(<VERSION>).*"
  }

  override string getAnEntryPoint() { result = "ko" }
}

/**
 * The AngularJS framework.
 */
private class AngularJS extends FrameworkLibraryWithGenericUrl {
  AngularJS() { this = "angularjs" }

  override string getAnAlias() { result = "angular" or result = "angular2" }

  override string getAnEntryPoint() { result = "angular" }
}

/**
 * Holds if comment `c` in toplevel `tl` is a marker comment for the given
 * `version` of AngularJS.
 *
 * Note that many versions of AngularJS do not include a marker comment.
 */
private predicate angularMarkerComment(Comment c, TopLevel tl, string version) {
  tl = c.getTopLevel() and
  (
    version = c.getText().regexpCapture("(?s).*AngularJS v(" + versionRegex() + ").*", 1)
    or
    c.getText().regexpMatch("(?s).*Copyright \\(c\\) 20.. Adam Abrons.*") and version = "unknown"
  )
}

/**
 * A copy of AngularJS.
 */
private class AngularJSInstance extends FrameworkLibraryInstance {
  AngularJSInstance() { angularMarkerComment(_, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof AngularJS and
    angularMarkerComment(_, this, v)
  }
}

/**
 * The Angular UI bootstrap framework.
 */
private class AngularUIBootstrap extends FrameworkLibraryWithGenericUrl {
  AngularUIBootstrap() { this = "angular-ui-bootstrap" }

  override string getAnAlias() { result = "ui-bootstrap" }
}

/**
 * Holds if comment `c` in toplevel `tl` is a marker comment for the given
 * `version` of AngularUI bootstrap.
 */
private predicate angularUIBootstrapMarkerComment(Comment c, TopLevel tl, string version) {
  tl = c.getTopLevel() and
  c.getText().regexpMatch("(?s).*angular-ui-bootstrap.*") and
  version = c.getText().regexpCapture("(?s).*Version: (" + versionRegex() + ").*", 1)
}

/**
 * A copy of Angular UI bootstrap.
 */
private class AngularUIBootstrapInstance extends FrameworkLibraryInstance {
  AngularUIBootstrapInstance() { angularUIBootstrapMarkerComment(_, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof AngularUIBootstrap and
    angularUIBootstrapMarkerComment(_, this, v)
  }
}

/**
 * The React framework.
 */
private class React extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  React() { this = "react" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*React(?:DOM(?:Server)?| \\(with addons\\))? v(<VERSION>).*"
  }
}

/**
 * The Microsoft AJAX Framework.
 */
private class MicrosoftAjaxFramework extends FrameworkLibrary {
  MicrosoftAjaxFramework() { this = "microsoft-ajax-framework" }
}

/**
 * Holds if comments `c1` and `c2` in toplevel `tl` are marker comments for the given
 * `version` of the Microsoft AJAX Framework.
 */
private predicate microsoftAjaxFrameworkMarkerComments(
  Comment c1, Comment c2, TopLevel tl, string version
) {
  tl = c1.getTopLevel() and
  tl = c2.getTopLevel() and
  c1.getText().regexpMatch("(?s).*Microsoft AJAX Framework.*") and
  version = c2.getText().regexpCapture("(?s).* Version:\\s*(" + versionRegex() + ").*", 1)
}

/**
 * A copy of the Microsoft AJAX Framework.
 */
private class MicrosoftAjaxFrameworkInstance extends FrameworkLibraryInstance {
  MicrosoftAjaxFrameworkInstance() { microsoftAjaxFrameworkMarkerComments(_, _, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof MicrosoftAjaxFramework and
    microsoftAjaxFrameworkMarkerComments(_, _, this, v)
  }
}

/**
 * The Polymer framework.
 */
private class Polymer extends FrameworkLibraryWithGenericUrl {
  Polymer() { this = "polymer" }

  override string getAnEntryPoint() { result = "Polymer" }
}

/**
 * Holds if toplevel `tl` looks like a copy of the given `version` of Polymer.
 */
private predicate isPolymer(TopLevel tl, string version) {
  // tl contains both a license comment...
  exists(Comment c | c.getTopLevel() = tl |
    c.getText().matches("%Copyright (c) 20__ The Polymer Project Authors. All rights reserved.%")
  ) and
  // ...and a version comment
  exists(Comment c | c.getTopLevel() = tl |
    version = c.getText().regexpCapture("(?s).*@version:? (" + versionRegex() + ").*", 1)
  )
}

/**
 * A copy of Polymer.
 */
private class PolymerInstance extends FrameworkLibraryInstance {
  PolymerInstance() { isPolymer(this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof Polymer and
    isPolymer(this, v)
  }
}

/**
 * The Vue.js framework.
 */
private class VueJS extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  VueJS() { this = "vue" }

  override string getAMarkerCommentRegex() { result = "(?s).*Vue\\.js v(<VERSION>).*" }

  override string getAnEntryPoint() { result = "Vue" }
}

/**
 * The Swagger UI framework.
 */
private class SwaggerUI extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  SwaggerUI() { this = "swagger-ui" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*swagger-ui - Swagger UI.*@version v(<VERSION>).*"
  }
}

/**
 * The Backbone.js framework.
 */
private class BackboneJS extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  BackboneJS() { this = "backbone" }

  override string getAMarkerCommentRegex() { result = "(?s).*Backbone\\.js (<VERSION>).*" }

  override string getAnEntryPoint() { result = "Backbone" }
}

/**
 * The Ember.js framework.
 */
private class EmberJS extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  EmberJS() { this = "ember" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*Ember - JavaScript Application Framework.*@version\\s*(<VERSION>).*"
  }

  override string getAnEntryPoint() { result = "Ember" }
}

/**
 * The QUnit.js framework.
 */
private class QUnitJS extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  QUnitJS() { this = "qunit" }

  override string getAMarkerCommentRegex() { result = "(?s).*QUnit\\s*(<VERSION>).*" }

  override string getAnEntryPoint() { result = "QUnit" }
}

/**
 * The Mocha framework.
 */
private class Mocha extends FrameworkLibraryWithGenericUrl {
  Mocha() { this = "mocha" }
}

/**
 * The Jasmine framework.
 */
private class Jasmine extends FrameworkLibraryWithGenericUrl {
  Jasmine() { this = "jasmine" }
}

/**
 * The Chai framework.
 */
private class Chai extends FrameworkLibraryWithGenericUrl {
  Chai() { this = "chai" }
}

/**
 * The Sinon.JS framework.
 */
private class SinonJS extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  SinonJS() { this = "sinon" }

  override string getAnAlias() { result = "sinon-ie" or result = "sinon-timers" }

  override string getAMarkerCommentRegex() { result = "(?s).*Sinon\\.JS\\s*(<VERSION>).*" }
}

/**
 * The TinyMCE framework.
 */
private class TinyMce extends FrameworkLibraryWithGenericUrl {
  TinyMce() { this = "tinymce" }

  override string getAnAlias() { result = "jquery.tinymce" or result = "tinymce.jquery" }
}

/**
 * The Require.js framework.
 */
private class RequireJS extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  RequireJS() { this = "requirejs" }

  override string getAnAlias() { result = "require.js" }

  override string getAMarkerCommentRegex() { result = "(?s).*RequireJS\\s*(<VERSION>).*" }
}

/**
 * A copy of the Microsoft ApplicationInsights framework.
 */
private class ApplicationInsightsInstance extends FrameworkLibraryInstance {
  string version;

  ApplicationInsightsInstance() {
    version =
      this.(TopLevel)
          .getFile()
          .getAbsolutePath()
          .regexpCapture(any(ApplicationInsights t).getAUrlRegex(), 1)
  }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof ApplicationInsights and
    version = v
  }
}

/**
 * The Microsoft ApplicationInsights framework.
 */
private class ApplicationInsights extends FrameworkLibraryWithUrlRegex {
  ApplicationInsights() { this = "ApplicationInsights" }

  override string getAUrlRegex() { result = ".*(?:^|/)ai\\.(" + semverRegex() + ")-build\\d+\\.js" }
}

/**
 * The twitter-text framework.
 */
private class TwitterText extends FrameworkLibraryWithGenericUrl, FrameworkLibraryWithMarkerComment {
  TwitterText() { this = "twitter-text" }

  override string getAMarkerCommentRegex() { result = "(?s).*twitter-text\\s*(<VERSION>).*" }
}

/**
 * The classic version of twitter-text, as seen in the wild.
 */
private class TwitterTextClassic extends FrameworkLibraryWithUrlRegex {
  TwitterTextClassic() { this = "twitter-text" }

  override string getAUrlRegex() { result = ".*(?:^|/)twitter_text" + variantRegex() + "\\.js" }
}

/**
 * A copy of twitter-text.
 */
private class TwitterTextClassicInstance extends FrameworkLibraryInstance {
  TwitterTextClassicInstance() {
    this.(TopLevel)
        .getFile()
        .getAbsolutePath()
        .regexpMatch(any(TwitterTextClassic t).getAUrlRegex())
  }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof TwitterTextClassic and
    v = ""
  }
}

/**
 * A `FrameworkLibraryReference` that refers to a recognised `FrameworkLibraryInstance`,
 * that is, a `<script>` tag where the `src` attribute can be resolved to a local file
 * that is recognised as an instance of a framework library.
 */
private class FrameworkLibraryReferenceToInstance extends FrameworkLibraryReference {
  FrameworkLibraryInstance fli;

  FrameworkLibraryReferenceToInstance() {
    fli = this.getElement().(HTML::ScriptElement).resolveSource()
  }

  override predicate info(FrameworkLibrary fl, string v) { fli.info(fl, v) }
}
