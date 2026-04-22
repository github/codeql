package com.github.codeql.utils.versions

import org.jetbrains.kotlin.descriptors.CallableMemberDescriptor
import org.jetbrains.kotlin.load.kotlin.getJvmModuleNameForDeserializedDescriptor

fun getJvmModuleNameForDeserializedDescriptor(descriptor: CallableMemberDescriptor): String? {
    return org.jetbrains.kotlin.load.kotlin.getJvmModuleNameForDeserializedDescriptor(descriptor)
}

