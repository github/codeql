package com.github.codeql.utils

import java.util.Stack
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.symbols.IrClassSymbol
import org.jetbrains.kotlin.ir.types.*

class ClassInstanceStack {
    private val stack: Stack<IrClass> = Stack()

    fun push(c: IrClass) = stack.push(c)
    fun pop() = stack.pop()

    private fun checkTypeArgs(sym: IrClassSymbol, args: List<IrTypeArgument>): Boolean {
        for (arg in args) {
            if (arg is IrTypeProjection) {
                if (checkType(sym, arg.type)) {
                    return true
                }
            }
        }
        return false
    }

    private fun checkType(sym: IrClassSymbol, type: IrType): Boolean {
        if (type is IrSimpleType) {
            val decl = type.classifier.owner
            if (decl.symbol == sym) {
                return true
            }
            if (checkTypeArgs(sym, type.arguments)) {
                return true
            }
        }
        return false
    }

    fun possiblyCyclicExtraction(classToCheck: IrClass, args: List<IrTypeArgument>): Boolean {
        for (c in stack) {
            if (c.symbol == classToCheck.symbol && checkTypeArgs(c.symbol, args)) {
                return true
            }
        }
        return false
    }
}

