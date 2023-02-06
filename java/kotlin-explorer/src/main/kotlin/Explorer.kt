package com.github.codeql
import kotlinx.metadata.internal.metadata.jvm.deserialization.JvmMetadataVersion
import kotlinx.metadata.jvm.*
import kotlinx.metadata.*

fun main(args : Array<String>) {
    /*
    Values from `javap -v` on TestKt.class from:

    class MyClass {}

    class MyParamClass<T> {}

    fun f(x: MyClass, y: MyClass?,
          l1: MyParamClass<MyClass>,
          l2: MyParamClass<MyClass?>,
          l3: MyParamClass<MyClass>?,
          l4: MyParamClass<MyClass?>?) {
    }
    */
    val kind = 2
    val metadataVersion = intArrayOf(1, 5, 1)
    val data1 = arrayOf("\u0000\u0018\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u001aX\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00032\u000c\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00030\u00062\u000e\u0010\u0007\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u00062\u000e\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u00062\u0010\u0010\t\u001a\u000c\u0012\u0006\u0012\u0004\u0018\u00010\u0003\u0018\u00010\u0006")
    val data2 = arrayOf("f","","x","LMyClass;","y","l1","LMyParamClass;","l2","l3","l4")
    val extraString = null
    val packageName = null
    val extraInt = 48
    val kch = KotlinClassHeader(kind, metadataVersion, data1, data2, extraString, packageName, extraInt)

    val md = KotlinClassMetadata.read(kch)
    when (md) {
        is KotlinClassMetadata.Class -> println("Metadata for Class not yet supported")
        is KotlinClassMetadata.FileFacade -> {
            println("Metadata for FileFacade:")
            val kmp = md.toKmPackage()
            kmp.accept(MyPackageVisitor(0))
        }
        is KotlinClassMetadata.SyntheticClass -> println("Metadata for SyntheticClass not yet supported")
        is KotlinClassMetadata.MultiFileClassFacade -> println("Metadata for MultiFileClassFacade not yet supported")
        is KotlinClassMetadata.MultiFileClassPart -> println("Metadata for MultiFileClassPart not yet supported")
        is KotlinClassMetadata.Unknown -> println("Unknown kind")
        else -> println("Unexpected kind")
    }
}

fun pr(indent: Int, s: String) {
    println("    ".repeat(indent) + s)
}

class MyPackageVisitor(val indent: Int): KmPackageVisitor() {
    override fun visitFunction(flags: Flags, name: String): KmFunctionVisitor? {
        pr(indent, "=> Function; flags:$flags, name:$name")
        return MyFunctionVisitor(indent + 1)
    }

    override fun visitProperty(flags: Flags, name: String, getterFlags: Flags, setterFlags: Flags): KmPropertyVisitor? {
        pr(indent, "=> Properties not yet handled")
        return null
    }

    override fun visitTypeAlias(flags: Flags, name: String): KmTypeAliasVisitor? {
        pr(indent, "=> Type aliases not yet handled")
        return null
    }

    override fun visitExtensions(type: KmExtensionType): KmPackageExtensionVisitor? {
        pr(indent, "=> Package extensions; type:$type")
        when (type) {
            JvmPackageExtensionVisitor.TYPE -> return MyJvmPackageExtensionVisitor(indent + 1)
            else -> {
                pr(indent, "- Not yet handled")
                return null
            }
        }
    }
}

class MyFunctionVisitor(val indent: Int): KmFunctionVisitor() {
    override fun visitTypeParameter(flags: Flags, name: String, id: Int, variance: KmVariance): KmTypeParameterVisitor? {
        pr(indent, "=> Type parameter; flags:$flags, name:$name, id:$id, variance:$variance")
        pr(indent, "    -> Not yet handled")
        return null
    }
    override fun visitReceiverParameterType(flags: Flags): KmTypeVisitor? {
        pr(indent, "=> Receiver parameter type; flags:$flags")
        pr(indent, "    -> Not yet handled")
        return null
    }

    override fun visitValueParameter(flags: Flags, name: String): KmValueParameterVisitor? {
        pr(indent, "=> Value parameter; flags:$flags, name:$name")
        return MyValueParameterVisitor(indent + 1)
    }

    override fun visitReturnType(flags: Flags): KmTypeVisitor? {
        pr(indent, "=> Return type; flags:$flags")
        return MyTypeVisitor(indent + 1)
    }

    override fun visitVersionRequirement(): KmVersionRequirementVisitor? {
        pr(indent, "=> VersionRequirement not yet handled")
        return null
    }

    override fun visitContract(): KmContractVisitor? {
        pr(indent, "=> Contract not yet handled")
        return null
    }

    override fun visitExtensions(type: KmExtensionType): KmFunctionExtensionVisitor? {
        pr(indent, "=> Function extensions; type:$type")
        when (type) {
            JvmFunctionExtensionVisitor.TYPE -> return MyJvmFunctionExtensionVisitor(indent + 1)
            else -> {
                pr(indent, "- Not yet handled")
                return null
            }
        }
    }
}

class MyValueParameterVisitor(val indent: Int): KmValueParameterVisitor() {
    override fun visitType(flags: Flags): KmTypeVisitor? {
        pr(indent, "=> Type; flags:$flags")
        return MyTypeVisitor(indent + 1)
    }

    override fun visitVarargElementType(flags: Flags): KmTypeVisitor? {
        pr(indent, "=> VarargElementType not yet handled")
        return null
    }

    override fun visitExtensions(type: KmExtensionType): KmValueParameterExtensionVisitor? {
        pr(indent, "=> Value parameter extensions; type:$type; not yet handled")
        return null
    }
}

class MyTypeVisitor(val indent: Int): KmTypeVisitor() {
    override fun visitClass(name: ClassName) {
        pr(indent, "=> Class; name:$name")
    }

    override fun visitTypeAlias(name: ClassName) {
        pr(indent, "=> Type alias; name:$name")
    }

    override fun visitTypeParameter(id: Int) {
        pr(indent, "=> Type parameter; id:$id")
    }

    override fun visitArgument(flags: Flags, variance: KmVariance): KmTypeVisitor? {
        pr(indent, "=> Argument; flags:$flags, variance:$variance")
        return MyTypeVisitor(indent + 1)
    }

    override fun visitStarProjection() {
        pr(indent, "=> Star projection")
    }

    override fun visitAbbreviatedType(flags: Flags): KmTypeVisitor? {
        pr(indent, "=> AbbreviatedType not yet handled")
        return null
    }

    override fun visitOuterType(flags: Flags): KmTypeVisitor? {
        pr(indent, "=> OuterType not yet handled")
        return null
    }

    override fun visitFlexibleTypeUpperBound(flags: Flags, typeFlexibilityId: String?): KmTypeVisitor? {
        pr(indent, "=> FlexibleTypeUpperBound not yet handled")
        return null
    }

    override fun visitExtensions(type: KmExtensionType): KmTypeExtensionVisitor? {
        pr(indent, "=> Type extensions; type:$type")
        when (type) {
            JvmTypeExtensionVisitor.TYPE -> return MyJvmTypeExtensionVisitor(indent + 1)
            else -> {
                pr(indent, "- Not yet handled")
                return null
            }
        }
    }
}

class MyJvmTypeExtensionVisitor(val indent: Int): JvmTypeExtensionVisitor() {
    override fun visit(isRaw: Boolean) {
        pr(indent, "=> isRaw:$isRaw")
    }

    override fun visitAnnotation(annotation: KmAnnotation) {
        pr(indent, "=> Annotation; annotation:$annotation")
    }
}

class MyJvmPackageExtensionVisitor(val indent: Int): JvmPackageExtensionVisitor() {
    override fun visitLocalDelegatedProperty(flags: Flags, name: String, getterFlags: Flags, setterFlags: Flags): KmPropertyVisitor? {
        pr(indent, "=> Local delegate not yet handled")
        return null
    }

    override fun visitModuleName(name: String) {
        pr(indent, "=> Module name; name:$name")
    }
}

class MyJvmFunctionExtensionVisitor(val indent: Int): JvmFunctionExtensionVisitor() {
    override fun visit(signature: JvmMethodSignature?) {
        pr(indent, "=> signature:$signature")
    }

    override fun visitLambdaClassOriginName(internalName: String) {
        pr(indent, "=> LambdaClassOriginName; internalName:$internalName")
    }
}
