package com.github.codeql.utils.versions

import com.github.codeql.KotlinUsesExtractor
import org.jetbrains.kotlin.backend.common.serialization.DescriptorByIdSignatureFinderImpl
import org.jetbrains.kotlin.idea.MainFunctionDetector
import org.jetbrains.kotlin.ir.ObsoleteDescriptorBasedAPI
import org.jetbrains.kotlin.ir.backend.jvm.serialization.JvmDescriptorMangler
import org.jetbrains.kotlin.ir.util.DeclarationStubGenerator
import org.jetbrains.kotlin.ir.util.SymbolTable
import org.jetbrains.kotlin.psi2ir.generators.DeclarationStubGeneratorImpl

@OptIn(ObsoleteDescriptorBasedAPI::class)
fun <TIrStub> KotlinUsesExtractor.getIrStubFromDescriptor(generateStub: (DeclarationStubGenerator) -> TIrStub) : TIrStub? =
    (pluginContext.symbolTable as? SymbolTable) ?.let {
        // Copying the construction seen in JvmIrLinker.kt
        val mangler = JvmDescriptorMangler(MainFunctionDetector(pluginContext.bindingContext, pluginContext.languageVersionSettings))
        val descriptorFinder = DescriptorByIdSignatureFinderImpl(
            pluginContext.moduleDescriptor,
            mangler,
            DescriptorByIdSignatureFinderImpl.LookupMode.MODULE_ONLY
        )
        val stubGenerator = DeclarationStubGeneratorImpl(pluginContext.moduleDescriptor, it, pluginContext.irBuiltIns, descriptorFinder)
        generateStub(stubGenerator)
    } ?: run {
        logger.error("Plugin context has no symbol table, couldn't get IR stub")
        null
    }
