package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.types.impl.IrTypeBase

fun getKotlinType(s: IrSimpleType) = (s as? IrTypeBase)?.kotlinType
