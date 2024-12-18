package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.jvm.codegen.isRawType
import org.jetbrains.kotlin.ir.types.IrSimpleType

fun IrSimpleType.codeQlIsRawType() = this.isRawType()
