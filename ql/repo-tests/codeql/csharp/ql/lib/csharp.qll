/**
 * The default C# QL library.
 */

import Customizations
import semmle.code.csharp.Attribute
import semmle.code.csharp.Callable
import semmle.code.csharp.Comments
import semmle.code.csharp.Element
import semmle.code.csharp.Event
import semmle.code.csharp.File
import semmle.code.csharp.Generics
import semmle.code.csharp.Location
import semmle.code.csharp.Member
import semmle.code.csharp.Namespace
import semmle.code.csharp.AnnotatedType
import semmle.code.csharp.Property
import semmle.code.csharp.Stmt
import semmle.code.csharp.Type
import semmle.code.csharp.Using
import semmle.code.csharp.Variable
import semmle.code.csharp.XML
import semmle.code.csharp.Preprocessor
import semmle.code.csharp.exprs.Access
import semmle.code.csharp.exprs.ArithmeticOperation
import semmle.code.csharp.exprs.Assignment
import semmle.code.csharp.exprs.BitwiseOperation
import semmle.code.csharp.exprs.Call
import semmle.code.csharp.exprs.ComparisonOperation
import semmle.code.csharp.exprs.Creation
import semmle.code.csharp.exprs.Dynamic
import semmle.code.csharp.exprs.Expr
import semmle.code.csharp.exprs.Literal
import semmle.code.csharp.exprs.LogicalOperation
import semmle.code.csharp.controlflow.ControlFlowGraph
import semmle.code.csharp.dataflow.DataFlow
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.dataflow.SSA

/** Whether the source was extracted without a build command. */
predicate extractionIsStandalone() { exists(SourceFile f | f.extractedStandalone()) }
