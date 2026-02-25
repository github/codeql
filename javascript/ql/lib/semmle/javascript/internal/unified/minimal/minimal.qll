/**
 * Provides classes for working with JavaScript programs, as well as JSON, YAML and HTML.
 */

import semmle.javascript.internal.unified.minimal.AST
import semmle.javascript.internal.unified.minimal.BasicBlocks
import semmle.javascript.internal.unified.minimal.CFG
import semmle.javascript.internal.unified.minimal.Classes
import semmle.javascript.internal.unified.minimal.Comments
import semmle.javascript.internal.unified.minimal.ES2015Modules
import semmle.javascript.internal.unified.minimal.Expr
import semmle.javascript.internal.unified.minimal.Files
import semmle.javascript.internal.unified.minimal.Functions
import semmle.javascript.internal.unified.minimal.JSDoc
import semmle.javascript.internal.unified.minimal.JSON
import semmle.javascript.internal.unified.minimal.JSX
import semmle.javascript.internal.unified.minimal.Lines
import semmle.javascript.internal.unified.minimal.Locations
import semmle.javascript.internal.unified.minimal.Paths
import semmle.javascript.internal.unified.minimal.Stmt
import semmle.javascript.internal.unified.minimal.Templates
import semmle.javascript.internal.unified.minimal.Tokens
import semmle.javascript.internal.unified.minimal.TypeAnnotations
import semmle.javascript.internal.unified.minimal.TypeScript
import semmle.javascript.internal.unified.minimal.Variables
import semmle.javascript.internal.unified.minimal.XML
import semmle.javascript.internal.unified.minimal.YAML
import semmle.javascript.internal.unified.minimal.PackageJsonEx
import semmle.javascript.internal.unified.minimal.NPM
private import semmle.javascript.internal.unified.minimal.Overlay
