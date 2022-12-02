package com.github.codeql

import com.github.codeql.utils.getJvmName
import com.intellij.openapi.vfs.StandardFileSystems
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass
import org.jetbrains.kotlin.load.kotlin.VirtualFileKotlinClass
import org.jetbrains.kotlin.load.kotlin.KotlinJvmBinarySourceElement

import com.intellij.openapi.vfs.VirtualFile
import org.jetbrains.kotlin.builtins.jvm.JavaToKotlinClassMap
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.util.fqNameWhenAvailable
import org.jetbrains.kotlin.ir.util.parentClassOrNull
import org.jetbrains.kotlin.load.kotlin.JvmPackagePartSource

// Adapted from Kotlin's interpreter/Utils.kt function 'internalName'
// Translates class names into their JLS section 13.1 binary name,
// and declarations within them into the parent class' JLS 13.1 name as
// specified above, followed by a `$` separator and then the short name
// for `that`.
private fun getName(d: IrDeclarationWithName) = (d as? IrAnnotationContainer)?.let { getJvmName(it) } ?: d.name.asString()

@OptIn(ExperimentalStdlibApi::class) // Annotation required by kotlin versions < 1.5
fun getFileClassName(f: IrFile) =
    getJvmName(f) ?:
        ((f.fileEntry.name.replaceFirst(Regex(""".*[/\\]"""), "")
        .replaceFirst(Regex("""\.kt$"""), "")
        .replaceFirstChar { it.uppercase() }) + "Kt")

fun getIrElementBinaryName(that: IrElement): String {
    if (that is IrFile) {
        val shortName = getFileClassName(that)
        val pkg = that.fqName.asString()
        return if (pkg.isEmpty()) shortName else "$pkg.$shortName"
    }

    if (that !is IrDeclaration) {
        return  "(unknown-name)"
    }

    val shortName = when(that) {
        is IrDeclarationWithName -> getName(that)
        else -> "(unknown-name)"
    }

    val internalName = StringBuilder(shortName)
    if (that !is IrClass) {
        val parent = that.parent
        if (parent is IrFile) {
            // Note we'll fall through and do the IrPackageFragment case as well, since IrFile <: IrPackageFragment
            internalName.insert(0, getFileClassName(parent) + "$")
        }
    }

    generateSequence(that.parent) { (it as? IrDeclaration)?.parent }
        .forEach {
            when (it) {
                is IrClass -> internalName.insert(0, getName(it) + "$")
                is IrPackageFragment -> it.fqName.asString().takeIf { fqName -> fqName.isNotEmpty() }?.let { fqName -> internalName.insert(0, "$fqName.") }
            }
        }
    return internalName.toString()
}

fun getIrClassVirtualFile(irClass: IrClass): VirtualFile? {
    val cSource = irClass.source
    // Don't emit a location for multi-file classes until we're sure we can cope with different declarations
    // inside a class disagreeing about their source file. In particular this currently causes problems when
    // a source-location for a declarations tries to refer to a file-id which is assumed to be declared in
    // the class trap file.
    if (irClass.origin == IrDeclarationOrigin.JVM_MULTIFILE_CLASS)
        return null
    when(cSource) {
        is JavaSourceElement -> {
            val element = cSource.javaElement
            when(element) {
                is BinaryJavaClass -> return element.virtualFile
            }
        }
        is KotlinJvmBinarySourceElement -> {
            val binaryClass = cSource.binaryClass
            when(binaryClass) {
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
        if(it.fileSystem.protocol == StandardFileSystems.JRT_PROTOCOL)
            // For JRT files, which we assume to be the JDK, hide the containing JAR path to match the Java extractor's behaviour.
            "/${path.split("!/", limit = 2)[1]}"
        else
            path
    }

fun getIrClassBinaryPath(irClass: IrClass): String {
  return getRawIrClassBinaryPath(irClass)
  // Otherwise, make up a fake location:
    ?: "/!unknown-binary-location/${getIrElementBinaryName(irClass).replace(".", "/")}.class"
}

fun getContainingClassOrSelf(decl: IrDeclaration): IrClass? {
    return when(decl) {
        is IrClass -> decl
        else -> decl.parentClassOrNull
    }
}

fun getJavaEquivalentClassId(c: IrClass) =
    c.fqNameWhenAvailable?.toUnsafe()?.let { JavaToKotlinClassMap.mapKotlinToJava(it) }
