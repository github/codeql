import Customizations
import semmle.python.Files
import semmle.python.Operations
import semmle.python.Variables
import semmle.python.AstGenerated
import semmle.python.AstExtended
import semmle.python.Function
import semmle.python.Module
import semmle.python.Class
import semmle.python.Import
import semmle.python.Stmts
import semmle.python.Exprs
import semmle.python.Patterns
import semmle.python.Keywords
import semmle.python.Comprehensions
import semmle.python.Flow
import semmle.python.Metrics
import semmle.python.Constants
import semmle.python.Scope
import semmle.python.Comment
import semmle.python.GuardedControlFlow
private import semmle.python.types.ImportTime
private import semmle.python.types.Object
private import semmle.python.types.ClassObject
private import semmle.python.types.FunctionObject
private import semmle.python.types.ModuleObject
private import semmle.python.types.Version
private import semmle.python.types.Descriptors
import semmle.python.SSA
private import semmle.python.SelfAttribute
private import semmle.python.types.Properties
import semmle.python.xml.XML
import semmle.python.essa.Essa
private import semmle.python.pointsto.Base
private import semmle.python.pointsto.Context
private import semmle.python.pointsto.CallGraph
private import semmle.python.objects.ObjectAPI
import semmle.python.Unit
import site
private import semmle.python.Overlay
// Removing this import perturbs the compilation process enough that the points-to analysis gets
// compiled -- and cached -- differently depending on whether the data flow library is imported. By
// importing it privately here, we ensure that the points-to analysis is compiled the same way.
private import semmle.python.dataflow.new.DataFlow
