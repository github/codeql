/** Top-level import for the Swift language pack */

import codeql.swift.elements
import codeql.swift.elements.expr.ArithmeticOperation
import codeql.swift.elements.expr.Assignment
import codeql.swift.elements.expr.BitwiseOperation
import codeql.swift.elements.expr.LogicalOperation
import codeql.swift.elements.expr.NilCoalescingExpr
import codeql.swift.elements.expr.InitializerLookupExpr
import codeql.swift.elements.expr.MethodApplyExpr
import codeql.swift.elements.expr.MethodCallExpr
import codeql.swift.elements.expr.InitializerCallExpr
import codeql.swift.elements.expr.SelfRefExpr
import codeql.swift.elements.expr.EnumElementExpr
import codeql.swift.elements.decl.FieldDecl
import codeql.swift.elements.decl.FreeFunction
import codeql.swift.elements.decl.Method
import codeql.swift.elements.decl.ClassOrStructDecl
import codeql.swift.elements.decl.SelfParamDecl
import codeql.swift.elements.decl.SetObserver
import codeql.swift.elements.type.NumericType
import codeql.swift.elements.Comments
import codeql.swift.elements.CompilerDiagnostics
import codeql.swift.Unit
