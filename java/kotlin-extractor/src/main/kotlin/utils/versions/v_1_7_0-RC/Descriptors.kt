package com.github.codeql.utils.versions

import com.github.codeql.KotlinUsesExtractor
import org.jetbrains.kotlin.ir.util.DeclarationStubGenerator

fun <TIrStub> KotlinUsesExtractor.getIrStubFromDescriptor(generateStub: (DeclarationStubGenerator) -> TIrStub) : TIrStub? {
    logger.error("Descriptors not yet supported for Kotlin 1.7")
    return null
}
