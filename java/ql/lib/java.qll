/** Provides all default Java QL imports. */
overlay[local?]
module;

import Customizations
import semmle.code.FileSystem
import semmle.code.Location
import semmle.code.Unit
import semmle.code.java.Annotation
import semmle.code.java.Compilation
import semmle.code.java.CompilationUnit
import semmle.code.java.ControlFlowGraph
import semmle.code.java.Dependency
import semmle.code.java.Element
import semmle.code.java.Exception
import semmle.code.java.Expr
import semmle.code.java.GeneratedFiles
import semmle.code.java.Generics
import semmle.code.java.Import
import semmle.code.java.J2EE
import semmle.code.java.Javadoc
import semmle.code.java.JDK
import semmle.code.java.JDKAnnotations
import semmle.code.java.JMX
import semmle.code.java.KotlinType
import semmle.code.java.Member
import semmle.code.java.Modifier
import semmle.code.java.Modules
import semmle.code.java.Package
import semmle.code.java.Statement
import semmle.code.java.Type
import semmle.code.java.UnitTests
import semmle.code.java.Variable
import semmle.code.java.controlflow.BasicBlocks
import semmle.code.java.metrics.MetricCallable
import semmle.code.java.metrics.MetricElement
import semmle.code.java.metrics.MetricField
import semmle.code.java.metrics.MetricPackage
import semmle.code.java.metrics.MetricRefType
import semmle.code.java.metrics.MetricStmt
import semmle.code.xml.Ant
import semmle.code.xml.XML
