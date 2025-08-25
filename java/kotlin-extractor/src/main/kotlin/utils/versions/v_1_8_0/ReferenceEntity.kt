package com.github.codeql.utils

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.symbols.*
import org.jetbrains.kotlin.name.CallableId
import org.jetbrains.kotlin.name.ClassId
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name

fun getClassByFqName(pluginContext: IrPluginContext, fqName: FqName): IrClassSymbol? {
    val id = ClassId.topLevel(fqName)
    return getClassByClassId(pluginContext, id)
}

fun getClassByClassId(pluginContext: IrPluginContext, id: ClassId): IrClassSymbol? {
    return pluginContext.referenceClass(id)
}

fun getFunctionsByFqName(
    pluginContext: IrPluginContext,
    pkgName: FqName,
    name: Name
): Collection<IrSimpleFunctionSymbol> {
    val id = CallableId(pkgName, name)
    return pluginContext.referenceFunctions(id)
}

fun getPropertiesByFqName(
    pluginContext: IrPluginContext,
    pkgName: FqName,
    name: Name
): Collection<IrPropertySymbol> {
    val id = CallableId(pkgName, name)
    return pluginContext.referenceProperties(id)
}
