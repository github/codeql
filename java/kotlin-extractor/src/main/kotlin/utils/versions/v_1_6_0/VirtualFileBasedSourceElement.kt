package org.jetbrains.kotlin.fir.java

import com.intellij.openapi.vfs.VirtualFile
import org.jetbrains.kotlin.descriptors.SourceElement
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass

/*
We need this class to exist, but the compiler will never give us an
instance of it.
*/
abstract class VirtualFileBasedSourceElement private constructor(val javaClass: BinaryJavaClass) : SourceElement {
    abstract val virtualFile: VirtualFile
}
