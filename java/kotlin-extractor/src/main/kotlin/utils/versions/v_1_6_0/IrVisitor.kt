package com.github.codeql.utils.versions

abstract class IrVisitor<R, D> : org.jetbrains.kotlin.ir.visitors.IrElementVisitor<R, D>
abstract class IrVisitorVoid : org.jetbrains.kotlin.ir.visitors.IrElementVisitorVoid