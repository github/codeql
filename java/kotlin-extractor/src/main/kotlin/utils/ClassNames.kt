package com.github.codeql

import com.intellij.openapi.vfs.StandardFileSystems
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass
import org.jetbrains.kotlin.load.kotlin.VirtualFileKotlinClass
import org.jetbrains.kotlin.load.kotlin.KotlinJvmBinarySourceElement

import com.intellij.openapi.vfs.VirtualFile
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.load.kotlin.JvmPackagePartSource

// Adapted from Kotlin's interpreter/Utils.kt function 'internalName'
// Translates class names into their JLS section 13.1 binary name,
// and declarations within them into the parent class' JLS 13.1 name as
// specified above, followed by a `$` separator and then a unique identifier
// for `that`, consisting of its short name followed by any supplied signature.
fun getIrDeclBinaryName(that: IrDeclaration, signature: String): String {
  val shortName = when(that) {
      is IrDeclarationWithName -> that.name.asString()
      else -> "(unknown-name)"
  }
  val internalName = StringBuilder(shortName + signature);
  generateSequence(that.parent) { (it as? IrDeclaration)?.parent }
      .forEach {
          when (it) {
              is IrClass -> internalName.insert(0, it.name.asString() + "$")
              is IrPackageFragment -> it.fqName.asString().takeIf { it.isNotEmpty() }?.let { internalName.insert(0, "$it.") }
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

fun getRawIrClassBinaryPath(irClass: IrClass) =
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
    ?: "/!unknown-binary-location/${getIrDeclBinaryName(irClass, "").replace(".", "/")}.class"
}
