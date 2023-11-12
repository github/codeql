package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.name.FqName

val IrFile.packageFqName: FqName
    get() = this.fqName

val IrPackageFragment.packageFqName: FqName
    get() = this.fqName
