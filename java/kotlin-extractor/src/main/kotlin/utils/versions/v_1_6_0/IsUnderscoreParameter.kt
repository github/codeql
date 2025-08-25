package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.ObsoleteDescriptorBasedAPI
import org.jetbrains.kotlin.ir.declarations.IrValueParameter
import org.jetbrains.kotlin.psi.KtParameter
import org.jetbrains.kotlin.resolve.DescriptorToSourceUtils
import org.jetbrains.kotlin.resolve.calls.util.isSingleUnderscore
import org.jetbrains.kotlin.utils.addToStdlib.safeAs

@OptIn(ObsoleteDescriptorBasedAPI::class)
fun isUnderscoreParameter(vp: IrValueParameter) =
    try {
        DescriptorToSourceUtils.getSourceFromDescriptor(vp.descriptor)
            ?.safeAs<KtParameter>()
            ?.isSingleUnderscore == true
    } catch (e: NotImplementedError) {
        // Some kinds of descriptor throw in `getSourceFromDescriptor` as that method is not
        // normally expected to
        // be applied to synthetic functions.
        false
    }
