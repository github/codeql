package com.github.codeql

import com.intellij.mock.MockProject
import org.jetbrains.kotlin.backend.common.IrElementTransformerVoidWithContext
import org.jetbrains.kotlin.backend.common.extensions.FirIncompatiblePluginAPI
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.backend.common.ir.addDispatchReceiver
import org.jetbrains.kotlin.backend.common.lower.DeclarationIrBuilder
import org.jetbrains.kotlin.compiler.plugin.ComponentRegistrar
import org.jetbrains.kotlin.compiler.plugin.ExperimentalCompilerApi
import org.jetbrains.kotlin.config.CompilerConfiguration
import org.jetbrains.kotlin.descriptors.ClassKind
import org.jetbrains.kotlin.descriptors.DescriptorVisibilities
import org.jetbrains.kotlin.descriptors.Modality
import org.jetbrains.kotlin.ir.IrStatement
import org.jetbrains.kotlin.ir.ObsoleteDescriptorBasedAPI
import org.jetbrains.kotlin.ir.builders.declarations.*
import org.jetbrains.kotlin.ir.builders.irCall
import org.jetbrains.kotlin.ir.builders.irExprBody
import org.jetbrains.kotlin.ir.builders.irGet
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.declarations.impl.IrExternalPackageFragmentImpl
import org.jetbrains.kotlin.ir.declarations.impl.IrFactoryImpl
import org.jetbrains.kotlin.ir.expressions.IrExpression
import org.jetbrains.kotlin.ir.expressions.impl.IrCallImpl
import org.jetbrains.kotlin.ir.expressions.impl.IrConstImpl
import org.jetbrains.kotlin.ir.expressions.impl.IrConstructorCallImpl
import org.jetbrains.kotlin.ir.symbols.IrClassSymbol
import org.jetbrains.kotlin.ir.symbols.IrConstructorSymbol
import org.jetbrains.kotlin.ir.symbols.IrSimpleFunctionSymbol
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.defaultType
import org.jetbrains.kotlin.ir.types.typeWith
import org.jetbrains.kotlin.ir.util.createImplicitParameterDeclarationWithWrappedDescriptor
import org.jetbrains.kotlin.ir.util.defaultType
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name

@OptIn(ExperimentalCompilerApi::class)
class TestComponentRegistrar : ComponentRegistrar {
    override fun registerProjectComponents(
        project: MockProject,
        configuration: CompilerConfiguration
    ) {
        IrGenerationExtension.registerExtension(project, IrAdder())
    }
}

@OptIn(ObsoleteDescriptorBasedAPI::class)
class IrAdder : IrGenerationExtension {
    override fun generate(moduleFragment: IrModuleFragment, pluginContext: IrPluginContext) {

        class AndroidSymbols {
            private val irFactory: IrFactory = IrFactoryImpl
            private val kotlinJvmInternalPackage: IrPackageFragment = createPackage("kotlin.jvm.internal")
            private val javaUtil: IrPackageFragment = createPackage("java.util")

            private fun createPackage(packageName: String): IrPackageFragment =
                IrExternalPackageFragmentImpl.createEmptyExternalPackageFragment(
                    moduleFragment.descriptor,
                    FqName(packageName)
                )

            private fun createClass(
                irPackage: IrPackageFragment,
                shortName: String,
                classKind: ClassKind,
                classModality: Modality
            ): IrClassSymbol = irFactory.buildClass {
                name = Name.identifier(shortName)
                kind = classKind
                modality = classModality
            }.apply {
                parent = irPackage
                createImplicitParameterDeclarationWithWrappedDescriptor()
            }.symbol

            val unsafeCoerceIntrinsic: IrSimpleFunctionSymbol =
                irFactory.buildFun {
                    name = Name.special("<unsafe-coerce>")
                    origin = IrDeclarationOrigin.IR_BUILTINS_STUB
                }.apply {
                    parent = kotlinJvmInternalPackage
                    val src = addTypeParameter("T", pluginContext.irBuiltIns.anyNType)
                    val dst = addTypeParameter("R", pluginContext.irBuiltIns.anyNType)
                    addValueParameter("v", src.defaultType)
                    returnType = dst.defaultType
                }.symbol

            val javaUtilArrayList: IrClassSymbol =
                createClass(javaUtil, "ArrayList", ClassKind.CLASS, Modality.OPEN)

            val javaUtilLinkedHashMap: IrClassSymbol =
                createClass(javaUtil, "LinkedHashMap", ClassKind.CLASS, Modality.OPEN)

            val arrayListConstructor: IrConstructorSymbol = javaUtilArrayList.owner.addConstructor().apply {
                addValueParameter("p_0", pluginContext.irBuiltIns.intType)
            }.symbol

            val arrayListAdd: IrSimpleFunctionSymbol =
                javaUtilArrayList.owner.addFunction("add", pluginContext.irBuiltIns.booleanType).apply {
                    addValueParameter("p_0", pluginContext.irBuiltIns.anyNType)
                }.symbol

            val linkedHashMapConstructor: IrConstructorSymbol =
                javaUtilLinkedHashMap.owner.addConstructor().apply {
                    addValueParameter("p_0", pluginContext.irBuiltIns.intType)
                }.symbol

            val linkedHashMapPut: IrSimpleFunctionSymbol =
                javaUtilLinkedHashMap.owner.addFunction("put", pluginContext.irBuiltIns.anyNType).apply {
                    addValueParameter("p_0", pluginContext.irBuiltIns.anyNType)
                    addValueParameter("p_1", pluginContext.irBuiltIns.anyNType)
                }.symbol
                }

        moduleFragment.transform(object: IrElementTransformerVoidWithContext() {
            override fun visitClassNew(declaration: IrClass): IrStatement {
                if (declaration.name.asString() == "A") {
                    addFunWithExprBody(declaration)
                } else if (declaration.name.asString() == "B") {
                    addFunWithUnsafeCoerce(declaration)
                } else if (declaration.name.asString() == "C") {
                    addFunWithStubClass(declaration)
                } else if (declaration.name.asString() == "D") {
                    addStaticFieldWithExprInit(declaration)
                } else if (declaration.name.asString() == "E") {
                    addFunWithArrayListAdd(declaration)
                    addFunWithLinkedHashMapPut(declaration)
                }

                return super.visitClassNew(declaration)
            }

            fun unsafeCoerce(value: IrExpression, fromType: IrType, toType: IrType): IrExpression {
                return IrCallImpl.fromSymbolOwner(-1, -1, toType, AndroidSymbols().unsafeCoerceIntrinsic).apply {
                    putTypeArgument(0, fromType)
                    putTypeArgument(1, toType)
                    putValueArgument(0, value)
                }
            }

            private fun arrayListAdd(): IrExpression {
                // ArrayList(1).add(null)
                var androidSymbols = AndroidSymbols()
                return IrCallImpl.fromSymbolOwner(-1, -1, pluginContext.irBuiltIns.booleanType, androidSymbols.arrayListAdd).apply {
                    dispatchReceiver = IrConstructorCallImpl.fromSymbolOwner(-1,-1, androidSymbols.javaUtilArrayList.typeWith(), androidSymbols.arrayListConstructor).apply {
                        putValueArgument(0, IrConstImpl.int(-1, -1, pluginContext.irBuiltIns.intType, 1))
                    }
                    putValueArgument(0, IrConstImpl.constNull(-1,-1, pluginContext.irBuiltIns.anyNType))
                }
            }

            private fun linkedHashMapPut(): IrExpression {
                // LinkedHashMap(1).put(null, null)
                var androidSymbols = AndroidSymbols()
                return IrCallImpl.fromSymbolOwner(-1, -1, pluginContext.irBuiltIns.anyNType, androidSymbols.linkedHashMapPut).apply {
                    dispatchReceiver = IrConstructorCallImpl.fromSymbolOwner(-1,-1, androidSymbols.javaUtilLinkedHashMap.typeWith(), androidSymbols.linkedHashMapConstructor).apply {
                        putValueArgument(0, IrConstImpl.int(-1, -1, pluginContext.irBuiltIns.intType, 1))
                    }
                    putValueArgument(0, IrConstImpl.constNull(-1,-1, pluginContext.irBuiltIns.anyNType))
                    putValueArgument(1, IrConstImpl.constNull(-1,-1, pluginContext.irBuiltIns.anyNType))
                }
            }

            private fun addFunWithArrayListAdd(declaration: IrClass) {
                declaration.declarations.add(pluginContext.irFactory.buildFun {
                    name = Name.identifier("<fn_ArrayListAdd>")
                    returnType = pluginContext.irBuiltIns.booleanType
                }. also {
                    it.body = DeclarationIrBuilder(pluginContext, it.symbol)
                        .irExprBody(
                            arrayListAdd()
                        )
                    it.parent = declaration
                })
            }

            private fun addFunWithLinkedHashMapPut(declaration: IrClass) {
                declaration.declarations.add(pluginContext.irFactory.buildFun {
                    name = Name.identifier("<fn_LinkedHashMap>")
                    returnType = pluginContext.irBuiltIns.anyNType
                }. also {
                    it.body = DeclarationIrBuilder(pluginContext, it.symbol)
                        .irExprBody(
                            linkedHashMapPut()
                        )
                    it.parent = declaration
                })
            }

            private fun addFunWithUnsafeCoerce(declaration: IrClass) {
                @OptIn(FirIncompatiblePluginAPI::class)
                val uintType = pluginContext.referenceClass(FqName("kotlin.UInt"))!!.owner.typeWith()
                declaration.declarations.add(pluginContext.irFactory.buildFun {
                    name = Name.identifier("<fn>")
                    returnType = uintType
                }. also {
                    it.body = DeclarationIrBuilder(pluginContext, it.symbol)
                        .irExprBody(
                            unsafeCoerce(IrConstImpl.int(-1, -1, pluginContext.irBuiltIns.intType, 1), pluginContext.irBuiltIns.intType, uintType)
                        )
                    it.parent = declaration
                })
            }

            private fun addFunWithExprBody(declaration: IrClass) {
                declaration.declarations.add(pluginContext.irFactory.buildFun {
                    name = Name.identifier("<fn>")
                    returnType = pluginContext.irBuiltIns.intType
                }. also {
                    it.body = DeclarationIrBuilder(pluginContext, it.symbol)
                        .irExprBody(
                            IrConstImpl.int(-1, -1, pluginContext.irBuiltIns.intType, 42)
                        )
                    it.parent = declaration
                })
            }

            private fun addStaticFieldWithExprInit(declaration: IrClass) {
                declaration.declarations.add(pluginContext.irFactory.buildProperty {
                    name = Name.identifier("bar")
                    isConst = true
                    visibility = DescriptorVisibilities.PRIVATE
                }.also { irProperty ->
                    irProperty.backingField = pluginContext.irFactory.buildField {
                        name = Name.identifier("bar")
                        type = pluginContext.irBuiltIns.stringType
                        isStatic = true
                        visibility = DescriptorVisibilities.PRIVATE
                    }.also { irField ->
                        irField.initializer =  DeclarationIrBuilder(pluginContext, irField.symbol)
                            .irExprBody(
                                IrConstImpl.string(-1, -1, pluginContext.irBuiltIns.stringType, "Foobar")
                            )
                        irField.parent = declaration
                    }
                    irProperty.parent = declaration
                })
            }

            val javaLangPackage = IrExternalPackageFragmentImpl.createEmptyExternalPackageFragment(pluginContext.moduleDescriptor, FqName("java.lang"))

            private fun makeJavaLangClass(fnName: String) = pluginContext.irFactory.buildClass {
                name = Name.identifier(fnName)
                kind = ClassKind.CLASS
                origin = IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB
            }.apply {
                parent = javaLangPackage
                createImplicitParameterDeclarationWithWrappedDescriptor()
            }

            // This adds a function with a parameter whose type is a real class without its supertypes specified,
            // mimicking the behaviour of the Kotlin android extensions gradle plugin, which refers to some real
            // Android classes through these sorts of synthetic, incomplete references. The extractor should
            // respond by replacing them with the real version available on the classpath.
            // I pick the particular java.lang class "ProcessBuilder" since it is (a) always available and
            // (b) not normally extracted by this project.
            private fun addFunWithStubClass(declaration: IrClass) {
                declaration.declarations.add(pluginContext.irFactory.buildFun {
                    name = Name.identifier("<fn>")
                    returnType = pluginContext.irBuiltIns.unitType
                }. also { addedFn ->
                    val processBuilderStub = makeJavaLangClass("ProcessBuilder")
                    val processBuilderStubType = processBuilderStub.defaultType
                    val startProcessMethod = processBuilderStub.addFunction {
                        name = Name.identifier("start")
                        origin = IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB
                        modality = Modality.FINAL
                        @OptIn(FirIncompatiblePluginAPI::class)
                        returnType = pluginContext.referenceClass(FqName("java.lang.Process"))!!.owner.defaultType
                    }.apply {
                        addDispatchReceiver { type = processBuilderStubType }
                    }

                    val paramSymbol = addedFn.addValueParameter("param", processBuilderStubType)
                    DeclarationIrBuilder(pluginContext, addedFn.symbol).apply {
                        addedFn.body = irExprBody(irCall(startProcessMethod).apply { dispatchReceiver = irGet(paramSymbol) })
                        addedFn.parent = declaration
                    }
                })
            }
        }, null)
    }
}
