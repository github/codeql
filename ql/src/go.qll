/**
 * Provides classes for working with Go programs.
 */

import Customizations
import semmle.go.AST
import semmle.go.Comments
import semmle.go.Concepts
import semmle.go.Decls
import semmle.go.Expr
import semmle.go.Files
import semmle.go.Locations
import semmle.go.Packages
import semmle.go.Scopes
import semmle.go.Stmt
import semmle.go.StringConcatenation
import semmle.go.Types
import semmle.go.controlflow.BasicBlocks
import semmle.go.controlflow.ControlFlowGraph
import semmle.go.controlflow.IR
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.GlobalValueNumbering
import semmle.go.dataflow.TaintTracking
import semmle.go.dataflow.SSA
import semmle.go.frameworks.HTTP
import semmle.go.frameworks.SystemCommandExecutors
import semmle.go.frameworks.SQL
import semmle.go.frameworks.Stdlib
import semmle.go.security.FlowSources
import semmle.go.Util
