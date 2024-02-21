package com.github.codeql.utils

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.symbols.*
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name

fun getClassByFqName(pluginContext: IrPluginContext, fqName: String): IrClassSymbol? {
    return getClassByFqName(pluginContext, FqName(fqName))
}

fun getFunctionsByFqName(
    pluginContext: IrPluginContext,
    pkgName: String,
    name: String
): Collection<IrSimpleFunctionSymbol> {
    return getFunctionsByFqName(pluginContext, FqName(pkgName), Name.identifier(name))
}

fun getPropertiesByFqName(
    pluginContext: IrPluginContext,
    pkgName: String,
    name: String
): Collection<IrPropertySymbol> {
    return getPropertiesByFqName(pluginContext, FqName(pkgName), Name.identifier(name))
}
