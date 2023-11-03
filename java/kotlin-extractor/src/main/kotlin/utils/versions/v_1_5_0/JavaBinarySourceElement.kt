package org.jetbrains.kotlin.fir.java

import org.jetbrains.kotlin.descriptors.SourceElement
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass

/*
We need this class to exist, but the compiler will never give us an
instance of it.
*/
abstract class JavaBinarySourceElement private constructor(val javaClass: BinaryJavaClass): SourceElement {
}
