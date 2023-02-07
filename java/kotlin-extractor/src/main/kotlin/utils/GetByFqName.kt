package com.github.codeql.utils

import org.jetbrains.kotlin.backend.common.extensions.FirIncompatiblePluginAPI
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.symbols.*
import org.jetbrains.kotlin.name.FqName

fun getClassByFqName(pluginContext: IrPluginContext, fqName: String): IrClassSymbol? {
    return getClassByFqName(pluginContext, FqName(fqName))
}

fun getClassByFqName(pluginContext: IrPluginContext, fqName: FqName): IrClassSymbol? {
    @OptIn(FirIncompatiblePluginAPI::class)
    return pluginContext.referenceClass(fqName)
}

fun getFunctionsByFqName(pluginContext: IrPluginContext, fqName: String): Collection<IrSimpleFunctionSymbol> {
    return getFunctionsByFqName(pluginContext, FqName(fqName))
}

private fun getFunctionsByFqName(pluginContext: IrPluginContext, fqName: FqName): Collection<IrSimpleFunctionSymbol> {
    @OptIn(FirIncompatiblePluginAPI::class)
    return pluginContext.referenceFunctions(fqName)
}

fun getPropertiesByFqName(pluginContext: IrPluginContext, fqName: String): Collection<IrPropertySymbol> {
    return getPropertiesByFqName(pluginContext, FqName(fqName))
}

private fun getPropertiesByFqName(pluginContext: IrPluginContext, fqName: FqName): Collection<IrPropertySymbol> {
    @OptIn(FirIncompatiblePluginAPI::class)
    return pluginContext.referenceProperties(fqName)
}
