package com.github.codeql

import com.github.codeql.utils.getJvmName
import com.github.codeql.utils.versions.*
import com.intellij.openapi.vfs.StandardFileSystems
import com.intellij.openapi.vfs.VirtualFile
import org.jetbrains.kotlin.builtins.jvm.JavaToKotlinClassMap
import org.jetbrains.kotlin.fir.java.VirtualFileBasedSourceElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.util.fqNameWhenAvailable
import org.jetbrains.kotlin.ir.util.parentClassOrNull
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass
import org.jetbrains.kotlin.load.kotlin.FacadeClassSource
import org.jetbrains.kotlin.load.kotlin.JvmPackagePartSource
import org.jetbrains.kotlin.load.kotlin.KotlinJvmBinarySourceElement
import org.jetbrains.kotlin.load.kotlin.VirtualFileKotlinClass
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.serialization.deserialization.descriptors.DeserializedContainerSource

// Adapted from Kotlin's interpreter/Utils.kt function 'internalName'
// Translates class names into their JLS section 13.1 binary name,
// and declarations within them into the parent class' JLS 13.1 name as
// specified above, followed by a `$` separator and then the short name
// for `that`.
private fun getName(d: IrDeclarationWithName) =
    (d as? IrAnnotationContainer)?.let { getJvmName(it) } ?: d.name.asString()

fun getFileClassName(f: IrFile) =
    getJvmName(f)
        ?: ((f.fileEntry.name
            .replaceFirst(Regex(""".*[/\\]"""), "")
            .replaceFirst(Regex("""\.kt$"""), "")
            .replaceFirstChar { it.uppercase() }) + "Kt")

fun getFileClassFqName(d: IrDeclaration): FqName? {
    // d is in a file class.
    // Get the name in a similar way to the compiler's ExternalPackageParentPatcherLowering
    // visitMemberAccess/generateOrGetFacadeClass.

    // But first, fields aren't IrMemberWithContainerSource, so we need
    // to get back to the property (if there is one)
    if (d is IrField) {
        val propSym = d.correspondingPropertySymbol
        if (propSym != null) {
            return getFileClassFqName(propSym.owner)
        }
    }

    // Now the main code
    if (d is IrMemberWithContainerSource) {
        val containerSource = d.containerSource
        if (containerSource is FacadeClassSource) {
            val facadeClassName = containerSource.facadeClassName
            if (facadeClassName != null) {
                // TODO: This is really a multifile-class rather than a file-class,
                // but for now we treat them the same.
                return facadeClassName.fqNameForTopLevelClassMaybeWithDollars
            } else {
                return containerSource.className.fqNameForTopLevelClassMaybeWithDollars
            }
        } else {
            return null
        }
    } else {
        return null
    }
}

fun getIrElementBinaryName(that: IrElement): String {
    if (that is IrFile) {
        val shortName = getFileClassName(that)
        val pkg = that.packageFqName.asString()
        return if (pkg.isEmpty()) shortName else "$pkg.$shortName"
    }

    if (that !is IrDeclaration) {
        return "(unknown-name)"
    }

    val shortName =
        when (that) {
            is IrDeclarationWithName -> getName(that)
            else -> "(unknown-name)"
        }

    val internalName = StringBuilder(shortName)
    if (that !is IrClass) {
        val parent = that.parent
        if (parent is IrFile) {
            // Note we'll fall through and do the IrPackageFragment case as well, since IrFile <:
            // IrPackageFragment
            internalName.insert(0, getFileClassName(parent) + "$")
        }
    }

    generateSequence(that.parent) { (it as? IrDeclaration)?.parent }
        .forEach {
            when (it) {
                is IrClass -> internalName.insert(0, getName(it) + "$")
                is IrPackageFragment ->
                    it.packageFqName
                        .asString()
                        .takeIf { fqName -> fqName.isNotEmpty() }
                        ?.let { fqName -> internalName.insert(0, "$fqName.") }
            }
        }
    return internalName.toString()
}

fun getIrClassVirtualFile(irClass: IrClass): VirtualFile? {
    val cSource = irClass.source
    // Don't emit a location for multi-file classes until we're sure we can cope with different
    // declarations
    // inside a class disagreeing about their source file. In particular this currently causes
    // problems when
    // a source-location for a declarations tries to refer to a file-id which is assumed to be
    // declared in
    // the class trap file.
    if (irClass.origin == IrDeclarationOrigin.JVM_MULTIFILE_CLASS) return null
    when (cSource) {
        is JavaSourceElement -> {
            val element = cSource.javaElement
            when (element) {
                is BinaryJavaClass -> return element.virtualFile
            }
        }
        is VirtualFileBasedSourceElement -> {
            if (cSource.virtualFile.name.endsWith(".class")) {
                // At least lately, despite VirtualFileBasedSourceElement being constructed on a BinaryJavaClass,
                // this can be a .java source file.
                return cSource.virtualFile
            }
        }
        is KotlinJvmBinarySourceElement -> {
            val binaryClass = cSource.binaryClass
            when (binaryClass) {
                is VirtualFileKotlinClass -> return binaryClass.file
            }
        }
        is JvmPackagePartSource -> {
            val binaryClass = cSource.knownJvmBinaryClass
            if (binaryClass != null && binaryClass is VirtualFileKotlinClass) {
                return binaryClass.file
            }
        }
    }
    return null
}

private fun getRawIrClassBinaryPath(irClass: IrClass) =
    getIrClassVirtualFile(irClass)?.let {
        val path = it.path
        if (it.fileSystem.protocol == StandardFileSystems.JRT_PROTOCOL)
        // For JRT files, which we assume to be the JDK, hide the containing JAR path to match the
        // Java extractor's behaviour.
        "/${path.split("!/", limit = 2)[1]}"
        else path
    }

fun getIrClassBinaryPath(irClass: IrClass): String {
    return getRawIrClassBinaryPath(irClass)
        // Otherwise, make up a fake location:
        ?: getUnknownBinaryLocation(getIrElementBinaryName(irClass))
}

fun getIrDeclarationBinaryPath(d: IrDeclaration): String? {
    if (d is IrClass) {
        return getIrClassBinaryPath(d)
    }
    val parentClass = d.parentClassOrNull
    if (parentClass != null) {
        return getIrClassBinaryPath(parentClass)
    }
    if (d.parent is IrExternalPackageFragment) {
        // This is in a file class.
        val fqName = getFileClassFqName(d)
        if (fqName != null) {
            if (d is IrMemberWithContainerSource) {
                val containerBinaryPath = getContainerSourceBinaryPath(d.containerSource)
                if (containerBinaryPath != null) {
                    return normalizeExternalFileClassBinaryPath(containerBinaryPath, fqName)
                }
            }
            return getUnknownBinaryLocation(fqName.asString())
        }
    }
    return null
}

/**
 * Attempts to get the binary file path from a container source (typically a
 * [JvmPackagePartSource]). Returns null if the path is unavailable.
 */
fun getContainerSourceBinaryPath(containerSource: org.jetbrains.kotlin.serialization.deserialization.descriptors.DeserializedContainerSource?): String? {
    if (containerSource !is JvmPackagePartSource) return null
    val binaryClass = containerSource.knownJvmBinaryClass ?: return null
    return when (binaryClass) {
        is VirtualFileKotlinClass -> {
            val vf = binaryClass.file
            val path = vf.path
            if (vf.fileSystem.protocol == StandardFileSystems.JRT_PROTOCOL)
                "/${path.split("!/", limit = 2)[1]}"
            else path
        }
        else -> binaryClass.location.takeIf { it.isNotEmpty() }
    }
}

private fun getUnknownBinaryLocation(s: String): String {
    return "/!unknown-binary-location/${s.replace(".", "/")}.class"
}

fun normalizeExternalFileClassBinaryPath(path: String, fqName: FqName): String {
    if (path.contains(".kotlinc_installed")) {
        return getUnknownBinaryLocation(fqName.asString())
    }
    val normalizedPath = path.replace('\\', '/')
    val classInternalPath = "${fqName.asString().replace(".", "/")}.class"
    val classSuffix = "/$classInternalPath"
    if (normalizedPath.endsWith(classSuffix)) {
        val classpathRoot = normalizedPath.removeSuffix(classSuffix).substringAfterLast('/')
        if (classpathRoot.isNotEmpty()) {
            return "$classpathRoot/$classInternalPath"
        }
    }
    return path
}

fun getJavaEquivalentClassId(c: IrClass) =
    c.fqNameWhenAvailable?.toUnsafe()?.let { JavaToKotlinClassMap.mapKotlinToJava(it) }

/**
 * Checks whether a specific parameter of a Java binary method (identified by [methodName] and
 * [paramIndex]) is a reference type (as opposed to a Java primitive). This is used to detect
 * cases where K2 FIR has enhanced a reference type parameter (e.g. `@NotNull Integer`) to a
 * Kotlin primitive (e.g. `kotlin.Int`), so that callable labels can use the original reference
 * type and remain compatible with the Java extractor's callable IDs.
 *
 * Under K1, binary Java classes use [JavaSourceElement] and we can check [BinaryJavaClass.methods]
 * directly. Under K2, they use [VirtualFileBasedSourceElement] and we fall back to reading the
 * class bytes with ASM.
 *
 * Returns `null` if the information cannot be determined.
 */
fun javaBinaryMethodParamIsClassifierType(
    parentClass: IrClass,
    methodName: String,
    nParams: Int,
    isConstructor: Boolean,
    paramIndex: Int
): Boolean? {
    // K1 path: binary Java class has JavaSourceElement with a BinaryJavaClass
    val binaryJavaClass = (parentClass.source as? JavaSourceElement)?.javaElement as? BinaryJavaClass
    if (binaryJavaClass != null) {
        val paramType = if (isConstructor) {
            binaryJavaClass.constructors
                .find { it.valueParameters.size == nParams }
                ?.valueParameters?.getOrNull(paramIndex)?.type
        } else {
            binaryJavaClass.methods
                .find { it.name.asString() == methodName && it.valueParameters.size == nParams }
                ?.valueParameters?.getOrNull(paramIndex)?.type
        }
        if (paramType != null) return paramType is org.jetbrains.kotlin.load.java.structure.JavaClassifierType
    }

    // K2 path: binary Java class has VirtualFileBasedSourceElement
    if (parentClass.source !is VirtualFileBasedSourceElement) return null
    val vf = (parentClass.source as VirtualFileBasedSourceElement).virtualFile
    if (!vf.name.endsWith(".class")) return null

    return try {
        val bytes = vf.contentsToByteArray()
        val expectedMethodName = if (isConstructor) "<init>" else methodName
        var result: Boolean? = null
        val reader = org.jetbrains.org.objectweb.asm.ClassReader(bytes)
        reader.accept(
            object : org.jetbrains.org.objectweb.asm.ClassVisitor(
                org.jetbrains.org.objectweb.asm.Opcodes.ASM9
            ) {
                override fun visitMethod(
                    access: Int,
                    name: String,
                    descriptor: String,
                    signature: String?,
                    exceptions: Array<String>?
                ): org.jetbrains.org.objectweb.asm.MethodVisitor? {
                    if (result != null || name != expectedMethodName) return null
                    val paramDescriptors = parseAsmMethodDescriptorParams(descriptor)
                    if (paramDescriptors.size != nParams) return null
                    val paramDesc = paramDescriptors.getOrNull(paramIndex) ?: return null
                    // Reference types start with 'L' or '['; Java primitives are single chars
                    result = paramDesc.startsWith("L") || paramDesc.startsWith("[")
                    return null
                }
            },
            org.jetbrains.org.objectweb.asm.ClassReader.SKIP_CODE or
                org.jetbrains.org.objectweb.asm.ClassReader.SKIP_DEBUG or
                org.jetbrains.org.objectweb.asm.ClassReader.SKIP_FRAMES
        )
        result
    } catch (e: Exception) {
        null
    }
}

/**
 * Checks whether the return type of a Java binary method (identified by [methodName] and
 * [nParams]) is a reference type (as opposed to a Java primitive).
 *
 * Returns `null` if the information cannot be determined.
 */
fun javaBinaryMethodReturnIsClassifierType(
    parentClass: IrClass,
    methodName: String,
    nParams: Int,
    isConstructor: Boolean
): Boolean? {
    if (isConstructor) return false

    // K1 path: binary Java class has JavaSourceElement with a BinaryJavaClass
    val binaryJavaClass = (parentClass.source as? JavaSourceElement)?.javaElement as? BinaryJavaClass
    if (binaryJavaClass != null) {
        val returnType =
            binaryJavaClass.methods
                .find { it.name.asString() == methodName && it.valueParameters.size == nParams }
                ?.returnType
        if (returnType != null)
            return returnType is org.jetbrains.kotlin.load.java.structure.JavaClassifierType
    }

    // K2 path: binary Java class has VirtualFileBasedSourceElement
    if (parentClass.source !is VirtualFileBasedSourceElement) return null
    val vf = (parentClass.source as VirtualFileBasedSourceElement).virtualFile
    if (!vf.name.endsWith(".class")) return null

    return try {
        val bytes = vf.contentsToByteArray()
        var result: Boolean? = null
        val reader = org.jetbrains.org.objectweb.asm.ClassReader(bytes)
        reader.accept(
            object : org.jetbrains.org.objectweb.asm.ClassVisitor(
                org.jetbrains.org.objectweb.asm.Opcodes.ASM9
            ) {
                override fun visitMethod(
                    access: Int,
                    name: String,
                    descriptor: String,
                    signature: String?,
                    exceptions: Array<String>?
                ): org.jetbrains.org.objectweb.asm.MethodVisitor? {
                    if (result != null || name != methodName) return null
                    if (parseAsmMethodDescriptorParams(descriptor).size != nParams) return null
                    val returnDescriptor = descriptor.substring(descriptor.lastIndexOf(')') + 1)
                    result = returnDescriptor.startsWith("L") || returnDescriptor.startsWith("[")
                    return null
                }
            },
            org.jetbrains.org.objectweb.asm.ClassReader.SKIP_CODE or
                org.jetbrains.org.objectweb.asm.ClassReader.SKIP_DEBUG or
                org.jetbrains.org.objectweb.asm.ClassReader.SKIP_FRAMES
        )
        result
    } catch (e: Exception) {
        null
    }
}

fun parseAsmMethodDescriptorParams(descriptor: String): List<String> {
    val params = mutableListOf<String>()
    var i = descriptor.indexOf('(') + 1
    val end = descriptor.lastIndexOf(')')
    while (i < end) {
        when (val c = descriptor[i]) {
            'L' -> {
                val semi = descriptor.indexOf(';', i)
                params.add(descriptor.substring(i, semi + 1))
                i = semi + 1
            }
            '[' -> {
                var j = i + 1
                while (j < end && descriptor[j] == '[') j++
                if (descriptor[j] == 'L') {
                    val semi = descriptor.indexOf(';', j)
                    params.add(descriptor.substring(i, semi + 1))
                    i = semi + 1
                } else {
                    params.add(descriptor.substring(i, j + 1))
                    i = j + 1
                }
            }
            else -> { params.add(c.toString()); i++ }
        }
    }
    return params
}
