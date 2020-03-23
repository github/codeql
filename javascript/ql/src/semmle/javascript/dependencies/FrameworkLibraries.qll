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
  FrameworkLibraryReference() { getName() = "src" and getElement() instanceof HTML::ScriptElement }

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
   * this framework library.
   *
   * The first capture group of this regular expression should match
   * the version number. Any occurrences of the string `<VERSION>` in
   * the regular expression are replaced by `versionRegex()` before
   * matching.
   */
  abstract string getAMarkerCommentRegex();
}

/**
 * A framework library that is referenced by URLs that have a certain
 * pattern.
 */
abstract class FrameworkLibraryWithURLRegex extends FrameworkLibrary {
  bindingset[this]
  FrameworkLibraryWithURLRegex() { this = this }

  /**
   * Gets a regular expression that can be used to identify a URL referring
   * to this framework library.
   *
   * The first capture group of this regular expression should match
   * the version number.
   */
  abstract string getAURLRegex();
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
abstract class FrameworkLibraryWithGenericURL extends FrameworkLibraryWithURLRegex {
  bindingset[this]
  FrameworkLibraryWithGenericURL() { this = this }

  /** Gets an alternative name of this library. */
  string getAnAlias() { none() }

  override string getAURLRegex() {
    exists(string id | id = getId() or id = getAnAlias() |
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

/**
 * Holds if comment `c` in toplevel `tl` matches the marker comment of library
 * `fl` at `version`.
 */
cached
private predicate matchMarkerComment(
  Comment c, TopLevel tl, FrameworkLibraryWithMarkerComment fl, string version
) {
  c.getTopLevel() = tl and
  exists(string r | r = fl.getAMarkerCommentRegex().replaceAll("<VERSION>", versionRegex()) |
    version = c.getText().regexpCapture(r, 1)
  )
}

/**
 * A reference to a `FrameworkLibraryWithURL`.
 */
class FrameworkLibraryReferenceWithURL extends FrameworkLibraryReference {
  FrameworkLibraryReferenceWithURL() { matchURL(this, _, _) }

  override predicate info(FrameworkLibrary fl, string v) { matchURL(this, fl, v) }
}

/**
 * Holds if the value of `src` attribute `attr` matches the URL pattern of library
 * `fl` at `version`.
 */
private predicate matchURL(HTML::Attribute attr, FrameworkLibraryWithURLRegex fl, string version) {
  attr.getName() = "src" and
  attr.getElement() instanceof HTML::ScriptElement and
  version = attr.getValue().regexpCapture(fl.getAURLRegex(), 1)
}

/**
 * Gets a regular expression for matching versions specified in marker comments.
 */
private string versionRegex() { result = "\\d+\\.\\d+[A-Za-z0-9.+_-]*" }

/**
 * The jQuery framework.
 */
private class JQuery extends FrameworkLibraryWithGenericURL {
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
    // more recent versions use this format
    version =
      txt.regexpCapture("(?s).*jQuery (?:JavaScript Library )?v(" + versionRegex() + ").*", 1)
    or
    // earlier versions used this format
    version = txt.regexpCapture("(?s).*jQuery (" + versionRegex() + ") - New Wave Javascript.*", 1)
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
private class JQueryMobile extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  JQueryMobile() { this = "jquery-mobile" }

  override string getAnAlias() { result = "jquery.mobile" }

  override string getAMarkerCommentRegex() { result = "(?s).*jQuery Mobile (<VERSION>).*" }

  override string getAnEntryPoint() { result = "$.mobile" or result = "jQuery.mobile" }
}

/**
 * The jQuery UI framework.
 */
private class JQueryUI extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  JQueryUI() { this = "jquery-ui" }

  override string getAMarkerCommentRegex() { result = "(?s).*jQuery UI - v?(<VERSION>).*" }

  override string getAnEntryPoint() { result = "$.ui" or result = "jQuery.ui" }
}

/**
 * The jQuery TextExt framework.
 */
private class JQueryTextExt extends FrameworkLibraryWithGenericURL,
  FrameworkLibraryWithMarkerComment {
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
private class JQueryDataTables extends FrameworkLibraryWithGenericURL,
  FrameworkLibraryWithMarkerComment {
  JQueryDataTables() { this = "jquery-dataTables" }

  override string getAnAlias() { result = "jquery.dataTables" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*@version\\s+(<VERSION>).*@file\\s+jquery\\.dataTables\\.js.*"
  }
}

/**
 * The jQuery jsTree framework.
 */
private class JQueryJsTree extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  JQueryJsTree() { this = "jquery-jstree" }

  override string getAnAlias() { result = "jquery.jstree" }

  override string getAMarkerCommentRegex() { result = "(?s).*jsTree (<VERSION>).*" }
}

/**
 * The jQuery Snippet framework.
 */
private class JQuerySnippet extends FrameworkLibraryWithGenericURL,
  FrameworkLibraryWithMarkerComment {
  JQuerySnippet() { this = "jquery-snippet" }

  override string getAnAlias() { result = "jquery.snippet" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*Snippet :: jQuery Syntax Highlighter v(<VERSION>).*"
  }
}

/**
 * The Bootstrap framework.
 */
private class Bootstrap extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  Bootstrap() { this = "bootstrap" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*Bootstrap v(<VERSION>) \\(http://getbootstrap.com\\).*"
  }

  override string getAnEntryPoint() { result = "$" }
}

/**
 * The Modernizr framework.
 */
private class Modernizr extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  Modernizr() { this = "modernizr" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*(?<!@license )Modernizr (?:JavaScript library )?v?(<VERSION>).*"
  }

  override string getAnEntryPoint() { result = "Modernizr" }
}

/**
 * The MooTools framework.
 */
private class MooTools extends FrameworkLibraryWithGenericURL {
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
private class Prototype extends FrameworkLibraryWithGenericURL {
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
private class Scriptaculous extends FrameworkLibraryWithGenericURL {
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
private class Underscore extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  Underscore() { this = "underscore" }

  override string getAMarkerCommentRegex() { result = "^\\s*Underscore.js (<VERSION>).*" }

  override string getAnEntryPoint() { result = "_" }
}

/**
 * The Lodash framework.
 */
private class Lodash extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  Lodash() { this = "lodash" }

  override string getAMarkerCommentRegex() {
    result =
      "(?s).* (?:lod|Lo-D)ash (<VERSION>)" + "(?: \\(Custom Build\\))? " +
        "<https?://lodash.com/>.*"
  }

  override string getAnEntryPoint() { result = "_" }
}

/** The Dojo framework. */
private class Dojo extends FrameworkLibraryWithGenericURL {
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
private class ExtJS extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
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
private class YUI extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  YUI() { this = "yui" }

  override string getAMarkerCommentRegex() { result = "(?s).*YUI (<VERSION>) \\(build \\d+\\).*" }

  override string getAnEntryPoint() { result = "YUI" }
}

/**
 * The Knockout framework.
 */
private class Knockout extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  Knockout() { this = "knockout" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*Knockout JavaScript library v(<VERSION>).*"
  }

  override string getAnEntryPoint() { result = "ko" }
}

/**
 * The AngularJS framework.
 */
private class AngularJS extends FrameworkLibraryWithGenericURL {
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
private class AngularUIBootstrap extends FrameworkLibraryWithGenericURL {
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
private class React extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  React() { this = "react" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*React(?:DOM(?:Server)?| \\(with addons\\))? v(<VERSION>).*"
  }
}

/**
 * The Microsoft AJAX Framework.
 */
private class MicrosoftAJAXFramework extends FrameworkLibrary {
  MicrosoftAJAXFramework() { this = "microsoft-ajax-framework" }
}

/**
 * Holds if comments `c1` and `c2` in toplevel `tl` are marker comments for the given
 * `version` of the Microsoft AJAX Framework.
 */
private predicate microsoftAJAXFrameworkMarkerComments(
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
private class MicrosoftAJAXFrameworkInstance extends FrameworkLibraryInstance {
  MicrosoftAJAXFrameworkInstance() { microsoftAJAXFrameworkMarkerComments(_, _, this, _) }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof MicrosoftAJAXFramework and
    microsoftAJAXFrameworkMarkerComments(_, _, this, v)
  }
}

/**
 * The Polymer framework.
 */
private class Polymer extends FrameworkLibraryWithGenericURL {
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
private class VueJS extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  VueJS() { this = "vue" }

  override string getAMarkerCommentRegex() { result = "(?s).*Vue\\.js v(<VERSION>).*" }

  override string getAnEntryPoint() { result = "Vue" }
}

/**
 * The Swagger UI framework.
 */
private class SwaggerUI extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  SwaggerUI() { this = "swagger-ui" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*swagger-ui - Swagger UI.*@version v(<VERSION>).*"
  }
}

/**
 * The Backbone.js framework.
 */
private class BackboneJS extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  BackboneJS() { this = "backbone" }

  override string getAMarkerCommentRegex() { result = "(?s).*Backbone\\.js (<VERSION>).*" }

  override string getAnEntryPoint() { result = "Backbone" }
}

/**
 * The Ember.js framework.
 */
private class EmberJS extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  EmberJS() { this = "ember" }

  override string getAMarkerCommentRegex() {
    result = "(?s).*Ember - JavaScript Application Framework.*@version\\s*(<VERSION>).*"
  }

  override string getAnEntryPoint() { result = "Ember" }
}

/**
 * The QUnit.js framework.
 */
private class QUnitJS extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  QUnitJS() { this = "qunit" }

  override string getAMarkerCommentRegex() { result = "(?s).*QUnit\\s*(<VERSION>).*" }

  override string getAnEntryPoint() { result = "QUnit" }
}

/**
 * The Mocha framework.
 */
private class Mocha extends FrameworkLibraryWithGenericURL {
  Mocha() { this = "mocha" }
}

/**
 * The Jasmine framework.
 */
private class Jasmine extends FrameworkLibraryWithGenericURL {
  Jasmine() { this = "jasmine" }
}

/**
 * The Chai framework.
 */
private class Chai extends FrameworkLibraryWithGenericURL {
  Chai() { this = "chai" }
}

/**
 * The Sinon.JS framework.
 */
private class SinonJS extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  SinonJS() { this = "sinon" }

  override string getAnAlias() { result = "sinon-ie" or result = "sinon-timers" }

  override string getAMarkerCommentRegex() { result = "(?s).*Sinon\\.JS\\s*(<VERSION>).*" }
}

/**
 * The TinyMCE framework.
 */
private class TinyMCE extends FrameworkLibraryWithGenericURL {
  TinyMCE() { this = "tinymce" }

  override string getAnAlias() { result = "jquery.tinymce" or result = "tinymce.jquery" }
}

/**
 * The Require.js framework.
 */
private class RequireJS extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
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
      this
          .(TopLevel)
          .getFile()
          .getAbsolutePath()
          .regexpCapture(any(ApplicationInsights t).getAURLRegex(), 1)
  }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof ApplicationInsights and
    version = v
  }
}

/**
 * The Microsoft ApplicationInsights framework.
 */
private class ApplicationInsights extends FrameworkLibraryWithURLRegex {
  ApplicationInsights() { this = "ApplicationInsights" }

  override string getAURLRegex() { result = ".*(?:^|/)ai\\.(" + semverRegex() + ")-build\\d+\\.js" }
}

/**
 * The twitter-text framework.
 */
private class TwitterText extends FrameworkLibraryWithGenericURL, FrameworkLibraryWithMarkerComment {
  TwitterText() { this = "twitter-text" }

  override string getAMarkerCommentRegex() { result = "(?s).*twitter-text\\s*(<VERSION>).*" }
}

/**
 * The classic version of twitter-text, as seen in the wild.
 */
private class TwitterTextClassic extends FrameworkLibraryWithURLRegex {
  TwitterTextClassic() { this = "twitter-text" }

  override string getAURLRegex() { result = ".*(?:^|/)twitter_text" + variantRegex() + "\\.js" }
}

/**
 * A copy of twitter-text.
 */
private class TwitterTextClassicInstance extends FrameworkLibraryInstance {
  TwitterTextClassicInstance() {
    this
        .(TopLevel)
        .getFile()
        .getAbsolutePath()
        .regexpMatch(any(TwitterTextClassic t).getAURLRegex())
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

  FrameworkLibraryReferenceToInstance() { fli = getElement().(HTML::ScriptElement).resolveSource() }

  override predicate info(FrameworkLibrary fl, string v) { fli.info(fl, v) }
}
