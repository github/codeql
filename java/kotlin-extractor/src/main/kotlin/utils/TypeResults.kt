package com.github.codeql

/**
 * A triple of a type's database label, its signature for use in callable signatures, and its short
 * name for use in all tables that provide a user-facing type name.
 *
 * `signature` is a Java primitive name (e.g. "int"), a fully-qualified class name
 * ("package.OuterClass.InnerClass"), or an array ("componentSignature[]") Type variables have the
 * signature of their upper bound. Type arguments and anonymous types do not have a signature.
 *
 * `shortName` is a Java primitive name (e.g. "int"), a class short name with Java-style type
 * arguments ("InnerClass<E>" or "OuterClass<ConcreteArgument>" or "OtherClass<? extends Bound>") or
 * an array ("componentShortName[]").
 */
data class TypeResultGeneric<SignatureType, out LabelType : AnyDbType>(
    val id: Label<out LabelType>,
    val signature: SignatureType?,
    val shortName: String
) {
    fun <U : AnyDbType> cast(): TypeResultGeneric<SignatureType, U> {
        @Suppress("UNCHECKED_CAST") return this as TypeResultGeneric<SignatureType, U>
    }
}

data class TypeResultsGeneric<SignatureType>(
    val javaResult: TypeResultGeneric<SignatureType, DbType>,
    val kotlinResult: TypeResultGeneric<SignatureType, DbKt_type>
)

typealias TypeResult<T> = TypeResultGeneric<String, T>

typealias TypeResultWithoutSignature<T> = TypeResultGeneric<Unit, T>

typealias TypeResults = TypeResultsGeneric<String>

typealias TypeResultsWithoutSignatures = TypeResultsGeneric<Unit>

fun <T : AnyDbType> TypeResult<T>.forgetSignature(): TypeResultWithoutSignature<T> {
    return TypeResultWithoutSignature(this.id, Unit, this.shortName)
}
