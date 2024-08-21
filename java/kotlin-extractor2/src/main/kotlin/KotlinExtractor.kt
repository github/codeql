import com.intellij.openapi.editor.Document
import com.intellij.psi.PsiFile
import java.nio.file.Paths
import org.jetbrains.kotlin.analysis.api.KaAnalysisApiInternals
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.analyze
import org.jetbrains.kotlin.analysis.api.platform.lifetime.KotlinAlwaysAccessibleLifetimeTokenProvider
import org.jetbrains.kotlin.analysis.api.platform.lifetime.KotlinLifetimeTokenProvider
import org.jetbrains.kotlin.analysis.api.projectStructure.KaSourceModule
import org.jetbrains.kotlin.analysis.api.standalone.buildStandaloneAnalysisAPISession
import org.jetbrains.kotlin.analysis.project.structure.builder.buildKtLibraryModule
import org.jetbrains.kotlin.analysis.project.structure.builder.buildKtSdkModule
import org.jetbrains.kotlin.analysis.project.structure.builder.buildKtSourceModule
import org.jetbrains.kotlin.platform.jvm.JvmPlatforms
import org.jetbrains.kotlin.psi.*

fun main(args : Array<String>) {
    println("Kotlin Extractor 2 running")
}
