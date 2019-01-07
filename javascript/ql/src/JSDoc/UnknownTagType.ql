/**
 * @name Unknown JSDoc tag
 * @description A JSDoc tag with a non-standard tag type will either be ignored or treated as plain
 *              text by JSDoc-processing tools.
 * @kind problem
 * @problem.severity recommendation
 * @id js/jsdoc/unknown-tag-type
 * @tags maintainability
 *       readability
 *       documentation
 * @precision low
 * @deprecated This query is prone to false positives. Deprecated since 1.17.
 */

import javascript

/** Holds if `tp` is a standard tag type. */
predicate knownTagType(string tp) {
  tp = "abstract" or
  tp = "access" or
  tp = "alias" or
  tp = "api" or
  tp = "arg" or
  tp = "argument" or
  tp = "augments" or
  tp = "author" or
  tp = "borrows" or
  tp = "bug" or
  tp = "callback" or
  tp = "category" or
  tp = "class" or
  tp = "classdesc" or
  tp = "const" or
  tp = "constant" or
  tp = "constructor" or
  tp = "constructs" or
  tp = "copyright" or
  tp = "default" or
  tp = "defaultvalue" or
  tp = "define" or
  tp = "depend" or
  tp = "depends" or
  tp = "deprecated" or
  tp = "desc" or
  tp = "description" or
  tp = "dict" or
  tp = "emits" or
  tp = "enum" or
  tp = "event" or
  tp = "example" or
  tp = "exception" or
  tp = "export" or
  tp = "exports" or
  tp = "expose" or
  tp = "extends" or
  tp = "external" or
  tp = "externs" or
  tp = "field" or
  tp = "file" or
  tp = "fileoverview" or
  tp = "final" or
  tp = "fires" or
  tp = "flow" or
  tp = "func" or
  tp = "function" or
  tp = "global" or
  tp = "host" or
  tp = "ignore" or
  tp = "implements" or
  tp = "implicitCast" or
  tp = "inheritDoc" or
  tp = "inner" or
  tp = "interface" or
  tp = "internal" or
  tp = "instance" or
  tp = "kind" or
  tp = "lends" or
  tp = "license" or
  tp = "link" or
  tp = "member" or
  tp = "memberof" or
  tp = "memberOf" or
  tp = "method" or
  tp = "mixes" or
  tp = "mixin" or
  tp = "modifies" or
  tp = "module" or
  tp = "modName" or
  tp = "mods" or
  tp = "name" or
  tp = "namespace" or
  tp = "ngInject" or
  tp = "noalias" or
  tp = "nocompile" or
  tp = "nosideeffects" or
  tp = "note" or
  tp = "override" or
  tp = "overview" or
  tp = "owner" or
  tp = "package" or
  tp = "param" or
  tp = "preserve" or
  tp = "preserveTry" or
  tp = "private" or
  tp = "prop" or
  tp = "property" or
  tp = "protected" or
  tp = "providesModule" or
  tp = "public" or
  tp = "readonly" or
  tp = "requires" or
  tp = "returns" or
  tp = "return" or
  tp = "see" or
  tp = "since" or
  tp = "static" or
  tp = "struct" or
  tp = "summary" or
  tp = "supported" or
  tp = "suppress" or
  tp = "template" or
  tp = "this" or
  tp = "throws" or
  tp = "todo" or
  tp = "tutorial" or
  tp = "type" or
  tp = "typedef" or
  tp = "var" or
  tp = "variation" or
  tp = "version" or
  tp = "virtual" or
  tp = "visibility" or
  tp = "wizaction" or
  tp = "wizmodule"
}

from JSDocTag tag
where not knownTagType(tag.getTitle())
select tag, "Unknown tag type '" + tag.getTitle() + "'."
