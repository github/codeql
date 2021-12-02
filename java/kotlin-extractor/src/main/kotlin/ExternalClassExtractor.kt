package com.github.codeql

import com.semmle.extractor.java.OdasaOutput
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.util.IdSignature
import java.io.File
import java.util.ArrayList
import java.util.HashSet
import java.util.zip.GZIPOutputStream

class ExternalClassExtractor(val logger: FileLogger, val sourceFilePath: String, val primitiveTypeMapping: PrimitiveTypeMapping, val pluginContext: IrPluginContext) {

    val externalClassesDone = HashSet<IrClass>()
    val externalClassWorkList = ArrayList<IrClass>()

    fun extractLater(c: IrClass): Boolean {
        val ret = externalClassesDone.add(c)
        if(ret) externalClassWorkList.add(c)
        return ret
    }

    fun extractExternalClasses() {
        val output = OdasaOutput(false, logger)
        output.setCurrentSourceFile(File(sourceFilePath))
        do {
            val nextBatch = ArrayList(externalClassWorkList)
            externalClassWorkList.clear()
            nextBatch.forEach { irClass ->
                output.getTrapLockerForClassFile(irClass).useAC { locker ->
                    locker.getTrapFileManager().useAC { manager ->
                        if(manager == null) {
                            logger.info("Skipping extracting class ${irClass.name}")
                        } else {
                            GZIPOutputStream(manager.getFile().outputStream()).bufferedWriter().use { trapFileBW ->
                                val binaryPath = getIrClassBinaryPath(irClass)
                                val tw =
                                    FileTrapWriter(TrapLabelManager(), trapFileBW, binaryPath, true)
                                val fileExtractor = KotlinFileExtractor(logger, tw, manager, this, primitiveTypeMapping, pluginContext)
                                fileExtractor.extractClassSource(irClass)
                            }
                        }
                    }
                }
            }
        } while (externalClassWorkList.isNotEmpty())
        output.writeTrapSet()
    }

}
