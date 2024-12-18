package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.types.IrSimpleType

fun getKotlinType(s: IrSimpleType) = s.kotlinType
