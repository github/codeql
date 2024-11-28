package com.github.codeql

import com.intellij.openapi.vfs.StandardFileSystems
import com.intellij.openapi.vfs.VirtualFile
import org.jetbrains.kotlin.analysis.api.symbols.KaClassSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaFileSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaNamedClassSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaSymbol
import org.jetbrains.kotlin.analysis.api.symbols.markers.KaNamedSymbol
import org.jetbrains.kotlin.name.ClassId
import org.jetbrains.kotlin.psi.*

/*
OLD: KE1
import com.github.codeql.utils.getJvmName
import com.github.codeql.utils.versions.*
import com.intellij.openapi.vfs.StandardFileSystems
import com.intellij.openapi.vfs.VirtualFile
import org.jetbrains.kotlin.builtins.jvm.JavaToKotlinClassMap
import org.jetbrains.kotlin.fir.java.JavaBinarySourceElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.util.fqNameWhenAvailable
import org.jetbrains.kotlin.ir.util.parentClassOrNull
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass
import org.jetbrains.kotlin.load.kotlin.JvmPackagePartSource
import org.jetbrains.kotlin.load.kotlin.KotlinJvmBinarySourceElement
import org.jetbrains.kotlin.load.kotlin.VirtualFileKotlinClass
*/

// Adapted from Kotlin's interpreter/Utils.kt function 'internalName'
// Translates class names into their JLS section 13.1 binary name,
// and declarations within them into the parent class' JLS 13.1 name as
// specified above, followed by a `$` separator and then the short name
// for `that`.
private fun getName(d: KaNamedSymbol) =
    d.name.identifier
    /* OLD: KE1
    (d as? IrAnnotationContainer)?.let { getJvmName(it) } ?: d.name.asString()
    */

fun getFileClassName(f: KtFile): String =
    null /* OLD: KE1: getJvmName(f) */
        ?: ((f.virtualFilePath
            .replaceFirst(Regex(""".*[/\\]"""), "")
            .replaceFirst(Regex("""\.kt$"""), "")
            .replaceFirstChar { it.uppercase() }) + "Kt")

private fun getBinaryName(cid: ClassId): String =
    (cid.outerClassId?.let { ocid -> "${getBinaryName(ocid)}\$" } ?: "${cid.packageFqName}.") + cid.shortClassName

fun getSymbolBinaryName(that: KaSymbol): String {
    if (that is KaFileSymbol) {
        return "TODO"
        /* OLD: KE1
        val shortName = getFileClassName(that)
        val pkg = that.packageFqName.asString()
        return if (pkg.isEmpty()) shortName else "$pkg.$shortName"
        */
    }

    /* OLD: KE1
    if (that !is IrDeclaration) {
        return "(unknown-name)"
    }
    */

    val internalName =
        (that as? KaNamedClassSymbol)?.classId?.let { getBinaryName(it) }
            ?: "(unknown-binary-name)"
    /* OLD: KE1
    if (that !is KaClassSymbol) {

        val parent = that.parent
        if (parent is IrFile) {
            // Note we'll fall through and do the IrPackageFragment case as well, since IrFile <:
            // IrPackageFragment
            internalName.insert(0, getFileClassName(parent) + "$")
        }
    }
    */

    return internalName
}

fun getIrClassVirtualFile(c: KaClassSymbol): VirtualFile? {
    return c.psi?.containingFile?.virtualFile
    /* OLD: KE1
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
        is JavaBinarySourceElement -> {
            return cSource.javaClass.virtualFile
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
    */
}

private fun getRawClassSymbolBinaryPath(c: KaClassSymbol) =
    getIrClassVirtualFile(c)?.let {
        val path = it.path
        if (it.fileSystem.protocol == StandardFileSystems.JRT_PROTOCOL)
        // For JRT files, which we assume to be the JDK, hide the containing JAR path to match the
        // Java extractor's behaviour.
        "/${path.split("!/", limit = 2)[1]}"
        else path
    }

fun getClassSymbolBinaryPath(c: KaClassSymbol): String {
    return getRawClassSymbolBinaryPath(c)
        // Otherwise, make up a fake location:
        ?: getUnknownBinaryLocation(getSymbolBinaryName(c))
}

fun getSymbolBinaryPath(d: KaSymbol): String? {
    if (d is KaClassSymbol) {
        return getClassSymbolBinaryPath(d)
    }
    /*
    OLD: KE1
    val parentClass = d.parentClassOrNull
    if (parentClass != null) {
        return getIrClassBinaryPath(parentClass)
    }
    if (d.parent is IrExternalPackageFragment) {
        // This is in a file class.
        val fqName = getFileClassFqName(d)
        if (fqName != null) {
            return getUnknownBinaryLocation(fqName.asString())
        }
    }
    */
    return null
}

private fun getUnknownBinaryLocation(s: String): String {
    return "/!unknown-binary-location/${s.replace(".", "/")}.class"
}

/* OLD: KE1
fun getJavaEquivalentClassId(c: IrClass) =
    c.fqNameWhenAvailable?.toUnsafe()?.let { JavaToKotlinClassMap.mapKotlinToJava(it) }
*/
