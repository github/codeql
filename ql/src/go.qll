/**
 * Provides classes for working with Go programs.
 */

import Customizations
import semmle.go.Architectures
import semmle.go.AST
import semmle.go.Comments
import semmle.go.Concepts
import semmle.go.Decls
import semmle.go.Errors
import semmle.go.Expr
import semmle.go.Files
import semmle.go.GoMod
import semmle.go.Locations
import semmle.go.Packages
import semmle.go.Scopes
import semmle.go.Stmt
import semmle.go.StringOps
import semmle.go.Types
import semmle.go.Util
import semmle.go.controlflow.BasicBlocks
import semmle.go.controlflow.ControlFlowGraph
import semmle.go.controlflow.IR
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.GlobalValueNumbering
import semmle.go.dataflow.SSA
import semmle.go.dataflow.TaintTracking
import semmle.go.frameworks.Chi
import semmle.go.frameworks.Email
import semmle.go.frameworks.Encoding
import semmle.go.frameworks.Gin
import semmle.go.frameworks.Glog
import semmle.go.frameworks.HTTP
import semmle.go.frameworks.Macaron
import semmle.go.frameworks.Mux
import semmle.go.frameworks.NoSQL
import semmle.go.frameworks.Protobuf
import semmle.go.frameworks.SQL
import semmle.go.frameworks.Stdlib
import semmle.go.frameworks.SystemCommandExecutors
import semmle.go.frameworks.Testing
import semmle.go.frameworks.WebSocket
import semmle.go.frameworks.XPath
import semmle.go.security.FlowSources
