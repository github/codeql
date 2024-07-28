package kotlin

/*
This is a mini standard library replacement, to make it easy to write
very small tests that create very small databases.

If you define a class, then you will need to also define any members that
compiler/ir/ir.psi2ir/src/org/jetbrains/kotlin/psi2ir/descriptors/IrBuiltInsOverDescriptors.kt
expects (e.g. with findFunctions(...).first) to exist.
*/

public open class Any {
    fun toString(): String { return this.toString() }
    open operator fun equals(other: Any?): Boolean { return this.equals(other) }
}

public class String {
    operator fun plus(other: Any?): String { return this.plus(other) }
}

public class Boolean {
    operator fun not(): Boolean { return this.not() }
}

public class Int {
    operator fun plus(other: Int): Int { return this.plus(other) }
    operator fun times(other: Int): Int { return this.times(other) }
    infix fun xor(other: Int): Int { return this.xor(other) }
}

public object Unit {
}

// Diagnostic Matches: % Can't find java.lang.Boolean
// Diagnostic Matches: % Can't find java.lang.Byte
// Diagnostic Matches: % Can't find java.lang.Character
// Diagnostic Matches: % Can't find java.lang.Double
// Diagnostic Matches: % Can't find java.lang.Float
// Diagnostic Matches: % Can't find java.lang.Integer
// Diagnostic Matches: % Can't find java.lang.Long
// Diagnostic Matches: % Can't find java.lang.Short
// Diagnostic Matches: % Can't find java.lang.Void
// Diagnostic Matches: % Can't find kotlin.UByte
// Diagnostic Matches: % Can't find kotlin.UInt
// Diagnostic Matches: % Can't find kotlin.ULong
// Diagnostic Matches: % Can't find kotlin.UShort
