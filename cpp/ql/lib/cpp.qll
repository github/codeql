/**
 * Provides classes and predicates for working with C/C++ code.
 *
 * Where the documentation refers to the standards, it gives
 * references to the freely-available drafts.
 *
 * For C++11, these references are of the form [N3337 5.3.2/1], and the
 * corresponding draft of the standard can be downloaded from
 *     https://github.com/cplusplus/draft/raw/master/papers/n3337.pdf
 *
 * For C++14, these references are of the form [N4140 5.3.2/1], and the
 * corresponding draft of the standard can be downloaded from
 *     https://github.com/cplusplus/draft/raw/master/papers/n4140.pdf
 */

import semmle.code.cpp.File
import semmle.code.cpp.Linkage
import semmle.code.cpp.Location
import semmle.code.cpp.Compilation
import semmle.code.cpp.Concept
import semmle.code.cpp.Element
import semmle.code.cpp.Namespace
import semmle.code.cpp.Specifier
import semmle.code.cpp.Declaration
import semmle.code.cpp.Include
import semmle.code.cpp.Macro
import semmle.code.cpp.Type
import semmle.code.cpp.TypedefType
import semmle.code.cpp.Class
import semmle.code.cpp.Struct
import semmle.code.cpp.Union
import semmle.code.cpp.Enum
import semmle.code.cpp.Member
import semmle.code.cpp.Field
import semmle.code.cpp.Function
import semmle.code.cpp.MemberFunction
import semmle.code.cpp.Parameter
import semmle.code.cpp.TemplateParameter
import semmle.code.cpp.Variable
import semmle.code.cpp.Initializer
import semmle.code.cpp.FriendDecl
import semmle.code.cpp.exprs.Expr
import semmle.code.cpp.exprs.ArithmeticOperation
import semmle.code.cpp.exprs.BitwiseOperation
import semmle.code.cpp.exprs.LogicalOperation
import semmle.code.cpp.exprs.ComparisonOperation
import semmle.code.cpp.exprs.Assignment
import semmle.code.cpp.exprs.Cast
import semmle.code.cpp.exprs.Access
import semmle.code.cpp.exprs.Call
import semmle.code.cpp.exprs.Lambda
import semmle.code.cpp.exprs.Literal
import semmle.code.cpp.exprs.BuiltInOperations
import semmle.code.cpp.stmts.Stmt
import semmle.code.cpp.stmts.Block
import semmle.code.cpp.metrics.MetricNamespace
import semmle.code.cpp.metrics.MetricClass
import semmle.code.cpp.metrics.MetricFile
import semmle.code.cpp.metrics.MetricFunction
import semmle.code.cpp.commons.CommonType
import semmle.code.cpp.commons.Printf
import semmle.code.cpp.commons.VoidContext
import semmle.code.cpp.commons.NULL
import semmle.code.cpp.commons.PolymorphicClass
import semmle.code.cpp.commons.Alloc
import semmle.code.cpp.commons.StructLikeClass
import semmle.code.cpp.controlflow.ControlFlowGraph
import semmle.code.cpp.XML
import semmle.code.cpp.Diagnostics
import semmle.code.cpp.Comments
import semmle.code.cpp.Preprocessor
import semmle.code.cpp.Iteration
import semmle.code.cpp.NameQualifiers
import DefaultOptions
