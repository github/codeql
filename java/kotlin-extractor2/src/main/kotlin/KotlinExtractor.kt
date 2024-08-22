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
import org.jetbrains.kotlin.cli.common.arguments.parseCommandLineArguments
import org.jetbrains.kotlin.cli.common.arguments.K2JVMCompilerArguments
import org.jetbrains.kotlin.platform.jvm.JvmPlatforms
import org.jetbrains.kotlin.psi.*

@OptIn(KaAnalysisApiInternals::class)
fun main(args : Array<String>) {
    lateinit var sourceModule: KaSourceModule
    val k2args : K2JVMCompilerArguments = parseCommandLineArguments(args.toList())

    val session = buildStandaloneAnalysisAPISession {
        registerProjectService(KotlinLifetimeTokenProvider::class.java, KotlinAlwaysAccessibleLifetimeTokenProvider())

        buildKtModuleProvider {
            platform = JvmPlatforms.defaultJvmPlatform
            val sdk = addModule(
                buildKtSdkModule {
                    addBinaryRootsFromJdkHome(Paths.get(System.getProperty("java.home")), isJre = true)
                    addBinaryRootsFromJdkHome(Paths.get(System.getProperty("java.home")), isJre = false)
                    platform = JvmPlatforms.defaultJvmPlatform
                    libraryName = "JDK"
                }
            )
            sourceModule = addModule(
                buildKtSourceModule {
                    addSourceRoots(k2args.freeArgs.map { Paths.get(it) })
                    addRegularDependency(sdk)
                    platform = JvmPlatforms.defaultJvmPlatform
                    moduleName = "<source>"
                }
            )
        }
    }

   val ktFile = session.modulesWithFiles.getValue(sourceModule).single() as KtFile
    analyze(ktFile) {
        val c = ktFile.getDeclarations()[0] as KtClass
        for (d: KtDeclaration in c.getDeclarations()) {
            val f = d as KtFunction
            if (f.name == "f") {
                dumpFunction(f)
            }
        }
    }
}

context (KaSession)
fun dumpFunction(f: KtFunction) {
    val block = f.getBodyExpression() as KtBlockExpression
    for (p: KtExpression in block.getStatements()) {
        dumpProperty(p as KtProperty)
    }
}

context (KaSession)
fun dumpProperty(p: KtProperty) {
    println("Got property ${p.name}")
    val i = p.getInitializer()!!
    val t = i.expressionType!!
    println("  Location: ${location(i)}")
    println("  Initializer type $t (${t.javaClass})")
    if (i is KtCallExpression) {
        println("  Call info: ${i.resolveToCall()}")
    }
}

fun location(e: KtElement): String {
    val range = e.getTextRange()
    val document = e.getContainingFile().getViewProvider().getDocument()
    val start = showOffset(document, range.getStartOffset(), 1)
    val end = showOffset(document, range.getEndOffset(), 0)
    return "$start-$end"
}

fun showOffset(document: Document, o: Int, colFudge: Int): String {
    val line = document.getLineNumber(o)
    val column = o - document.getLineStartOffset(line)
    return "${line + 1}:${column + colFudge}"
}
