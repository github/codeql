package com.github.codeql.utils.versions

import org.jetbrains.kotlin.descriptors.*
import org.jetbrains.kotlin.load.kotlin.JvmPackagePartSource
import org.jetbrains.kotlin.metadata.deserialization.*
import org.jetbrains.kotlin.metadata.jvm.deserialization.*
import org.jetbrains.kotlin.metadata.jvm.JvmProtoBuf
import org.jetbrains.kotlin.resolve.DescriptorUtils.*
import org.jetbrains.kotlin.serialization.deserialization.descriptors.*

fun getJvmModuleNameForDeserializedDescriptor(descriptor: CallableMemberDescriptor): String? {
    val parent = getParentOfType(descriptor, ClassOrPackageFragmentDescriptor::class.java, false)

    when {
        parent is DeserializedClassDescriptor -> {
            val classProto = parent.classProto
            val nameResolver = parent.c.nameResolver
            return classProto.getExtensionOrNull(JvmProtoBuf.classModuleName)
                ?.let(nameResolver::getString)
                ?: JvmProtoBufUtil.DEFAULT_MODULE_NAME
        }
        descriptor is DeserializedMemberDescriptor -> {
            val source = descriptor.containerSource
            if (source is JvmPackagePartSource) {
                return source.moduleName
            }
        }
    }

    return null
}
