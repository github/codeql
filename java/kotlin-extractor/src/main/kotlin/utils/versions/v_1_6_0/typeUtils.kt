package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.types.*
import org.jetbrains.kotlin.ir.IrBuiltIns

fun IrType.isNullableCodeQL(): Boolean =
    this.isNullable()

val IrType.isBoxedArrayCodeQL: Boolean by IrType::isBoxedArray

fun IrType.getArrayElementTypeCodeQL(irBuiltIns: IrBuiltIns): IrType =
   this.getArrayElementType(irBuiltIns)
