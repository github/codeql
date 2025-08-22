package com.github.codeql

import org.jetbrains.kotlin.ir.declarations.IrDeclaration

/**
 * This behaves the same as Iterable<IrDeclaration>.find, but requires that the value found is of
 * the subtype S, and it casts the result for you appropriately.
 */
inline fun <reified S : IrDeclaration> Iterable<IrDeclaration>.findSubType(
    predicate: (S) -> Boolean
): S? {
    return this.find { it is S && predicate(it) } as S?
}
