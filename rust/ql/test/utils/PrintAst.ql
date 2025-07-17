/**
 * @name Print AST
 * @description Outputs a representation of a file's Abstract Syntax Tree
 * @id rust/test/print-ast
 * @kind graph
 */

import rust
import codeql.rust.printast.PrintAst
import codeql.rust.elements.internal.generated.ParentChild
import TestUtils

predicate shouldPrint(Locatable e) { toBeTested(e) }

import PrintAst<shouldPrint/1>
