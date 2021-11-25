package com.github.codeql

import com.intellij.openapi.vfs.StandardFileSystems
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrDeclaration
import org.jetbrains.kotlin.ir.declarations.IrDeclarationParent
import org.jetbrains.kotlin.ir.declarations.IrPackageFragment
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass
import org.jetbrains.kotlin.load.kotlin.VirtualFileKotlinClass
import org.jetbrains.kotlin.load.kotlin.KotlinJvmBinarySourceElement

import com.intellij.openapi.vfs.VirtualFile

// Taken from Kotlin's interpreter/Utils.kt function 'internalName'
// Translates class names into their JLS section 13.1 binary name
fun getIrClassBinaryName(that: IrClass): String {
  val internalName = StringBuilder(that.name.asString())
  generateSequence(that as? IrDeclarationParent) { (it as? IrDeclaration)?.parent }
      .drop(1)
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
    ?: "/!unknown-binary-location/${getIrClassBinaryName(irClass).replace(".", "/")}.class"
}
