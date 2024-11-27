package com.github.codeql

import com.semmle.extractor.java.OdasaOutput
import com.semmle.util.data.StringDigestor
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.analysis.api.symbols.markers.KaNamedSymbol
import java.io.BufferedWriter
import java.io.File
import java.lang.Error
import java.util.ArrayList
import java.util.HashSet

context (KaSession)
class ExternalDeclExtractor(
    val logger: FileLogger,
    val compression: Compression,
    val invocationTrapFile: String,
    val sourceFilePath: String,
    /* OLD: KE1
    val primitiveTypeMapping: PrimitiveTypeMapping,
    val pluginContext: IrPluginContext,
    val globalExtensionState: KotlinExtractorGlobalState,
     */
    val diagnosticTrapWriter: DiagnosticTrapWriter
) {

    val declBinaryNames = HashMap<KaSymbol, String>()
    val externalDeclsDone = HashSet<Pair<String, String>>()
    val externalDeclWorkList = ArrayList<Pair<KaSymbol, String>>()

    val propertySignature = ";property"
    val fieldSignature = ";field"

    val output =
        OdasaOutput(false, compression, logger).also {
            it.setCurrentSourceFile(File(sourceFilePath))
        }

    fun extractLater(d: KaSymbol, signature: String): Boolean {
        /* OLD: KE1
        if (d !is IrClass && !isExternalFileClassMember(d)) {
            logger.errorElement(
                "External declaration is neither a class, nor a top-level declaration",
                d
            )
            return false
        }
        */
        val declBinaryName = declBinaryNames.getOrPut(d) { getSymbolBinaryName(d) }
        val ret = externalDeclsDone.add(Pair(declBinaryName, signature))
        if (ret) externalDeclWorkList.add(Pair(d, signature))
        return ret
    }

    fun extractLater(c: KaClassSymbol) = extractLater(c, "")

    fun writeStubTrapFile(e: KaSymbol, signature: String = "") {
        extractElement(e, signature, true) { trapFileBW, _, _ ->
            trapFileBW.write(
                "// Trap file stubbed because this declaration was extracted from source in $sourceFilePath\n"
            )
            trapFileBW.write("// Part of invocation $invocationTrapFile\n")
        }
    }

    private fun extractElement(
        element: KaSymbol,
        possiblyLongSignature: String,
        fromSource: Boolean,
        extractorFn: (BufferedWriter, String, OdasaOutput.TrapFileManager) -> Unit
    ) {
        // In order to avoid excessively long signatures which can lead to trap file names longer
        // than the filesystem
        // limit, we truncate and add a hash to preserve uniqueness if necessary.
        val signature =
            if (possiblyLongSignature.length > 100) {
                possiblyLongSignature.substring(0, 92) +
                    "#" +
                    StringDigestor.digest(possiblyLongSignature).substring(0, 8)
            } else {
                possiblyLongSignature
            }
        output.getTrapLockerForDecl(element, signature, fromSource).useAC { locker ->
            locker.trapFileManager.useAC { manager ->
                val shortName =
                    when (element) {
                        is KaNamedSymbol -> element.name.asString()
                        is KaFileSymbol -> "(TODO file symbol name)"
                        else -> "(unknown name)"
                    }
                if (manager == null) {
                    logger.info("Skipping extracting external decl $shortName")
                } else {
                    val trapFile = manager.file
                    logger.info("Will write TRAP file $trapFile")
                    val trapTmpFile =
                        File.createTempFile(
                            "${trapFile.nameWithoutExtension}.",
                            ".${trapFile.extension}.tmp",
                            trapFile.parentFile
                        )
                    logger.debug("Writing temporary TRAP file $trapTmpFile")
                    try {
                        compression.bufferedWriter(trapTmpFile).use {
                            extractorFn(it, signature, manager)
                        }

                        if (!trapTmpFile.renameTo(trapFile)) {
                            logger.error("Failed to rename $trapTmpFile to $trapFile")
                        }
                        logger.info("Finished writing TRAP file $trapFile")
                    } catch (e: Throwable) {
                        manager.setHasError()
                        logger.error(
                            "Failed to extract '$shortName'. Partial TRAP file location is $trapTmpFile",
                            e
                        )
                    }
                }
            }
        }
    }

    fun extractExternalClasses() {
        do {
            val nextBatch = ArrayList(externalDeclWorkList)
            externalDeclWorkList.clear()
            nextBatch.forEach { workPair ->
                val (sym, possiblyLongSignature) = workPair
                extractElement(sym, possiblyLongSignature, false) {
                    trapFileBW,
                    signature,
                    manager ->
                    val binaryPath = getSymbolBinaryPath(sym)
                    if (binaryPath == null) {
                        sym.psi?.also {
                            logger.errorElement("Unable to get binary path", it)
                        } ?: logger.error("Unable to get binary path")
                    } else {
                        // We want our comments to be the first thing in the file,
                        // so start off with a PlainTrapWriter
                        val tw =
                            PlainTrapWriter(
                                logger.loggerBase,
                                TrapLabelManager(),
                                trapFileBW,
                                diagnosticTrapWriter
                            )
                        tw.writeComment(
                            "Generated by the CodeQL Kotlin extractor for external dependencies"
                        )
                        tw.writeComment("Part of invocation $invocationTrapFile")
                        if (signature != possiblyLongSignature) {
                            tw.writeComment(
                                "Function signature abbreviated; full signature is: $possiblyLongSignature"
                            )
                        }
                        // Now elevate to a SourceFileTrapWriter, and populate the
                        // file information if needed:
                        val ftw = tw.makeFileTrapWriter(binaryPath, true)

                        val fileExtractor =
                            KotlinFileExtractor(
                                logger,
                                ftw,
                                this,
                                /* OLD: KE1
                                null,
                                binaryPath,
                                manager,
                                primitiveTypeMapping,
                                pluginContext,
                                KotlinFileExtractor.DeclarationStack(),
                                globalExtensionState
                                */
                            )

                        if (sym is KaClassSymbol) {
                            // Populate a location and compilation-unit package for the file. This
                            // is similar to
                            // the beginning of `KotlinFileExtractor.extractFileContents` but
                            // without an `IrFile`
                            // to start from.
                            val pkg = sym.classId?.packageFqName?.asString() ?: ""
                            val pkgId = fileExtractor.extractPackage(pkg)
                            ftw.writeHasLocation(ftw.fileId, ftw.getWholeFileLocation())
                            ftw.writeCupackage(ftw.fileId, pkgId)

                            fileExtractor.extractClassSource(
                                sym,
                                extractDeclarations = /* OLD: KE1 !sym.isFileClass */true,
                                /* OLD: KE1
                                extractStaticInitializer = false,
                                extractPrivateMembers = false,
                                extractFunctionBodies = false
                                */
                            )
                        } else {
                            fileExtractor.extractDeclaration(
                                sym as KaDeclarationSymbol,
                                /* OLD: KE1
                                extractPrivateMembers = false,
                                extractFunctionBodies = false,
                                extractAnnotations = true
                                */
                            )
                        }
                    }
                }
            }
        } while (externalDeclWorkList.isNotEmpty())
        output.writeTrapSet()
    }
}
