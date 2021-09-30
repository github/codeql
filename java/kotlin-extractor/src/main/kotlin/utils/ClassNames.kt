package com.github.codeql

import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrDeclaration
import org.jetbrains.kotlin.ir.declarations.IrDeclarationParent
import org.jetbrains.kotlin.ir.declarations.IrPackageFragment
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass
import org.jetbrains.kotlin.load.kotlin.KotlinJvmBinarySourceElement

// Taken from Kotlin's interpreter/Utils.kt function 'internalName'
// Translates class names into their JLS section 13.1 binary name
fun getClassBinaryName(that: IrClass): String {
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

fun getRawIrClassBinaryPath(irClass: IrClass): String? {
  val cSource = irClass.source
  when(cSource) {
      is JavaSourceElement -> {
          val element = cSource.javaElement
          when(element) {
              is BinaryJavaClass -> return element.virtualFile.getPath()
          }
      }
      is KotlinJvmBinarySourceElement -> {
          return cSource.binaryClass.location
      }
  }
  return null
}

fun getIrClassBinaryPath(irClass: IrClass): String {
  // If a class location is known, replace the JAR delimiter !/:
  return getRawIrClassBinaryPath(irClass)?.replaceFirst("!/", "/")
  // Otherwise, make up a fake location:
    ?: "/!unknown-binary-location/${getClassBinaryName(irClass).replace(".", "/")}.class"
}
