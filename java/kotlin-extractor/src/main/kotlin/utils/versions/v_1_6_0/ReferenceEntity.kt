package com.github.codeql.utils

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.symbols.*
import org.jetbrains.kotlin.name.ClassId
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name

fun getClassByFqName(pluginContext: IrPluginContext, fqName: FqName): IrClassSymbol? {
    return pluginContext.referenceClass(fqName)
}

fun getClassByClassId(pluginContext: IrPluginContext, id: ClassId): IrClassSymbol? {
    return getClassByFqName(pluginContext, id.asSingleFqName())
}

fun getFunctionsByFqName(
    pluginContext: IrPluginContext,
    pkgName: FqName,
    name: Name
): Collection<IrSimpleFunctionSymbol> {
    val fqName = pkgName.child(name)
    return pluginContext.referenceFunctions(fqName)
}

fun getPropertiesByFqName(
    pluginContext: IrPluginContext,
    pkgName: FqName,
    name: Name
): Collection<IrPropertySymbol> {
    val fqName = pkgName.child(name)
    return pluginContext.referenceProperties(fqName)
}
