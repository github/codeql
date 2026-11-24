package com.github.codeql.comments

import com.intellij.openapi.project.Project
import java.lang.ref.WeakReference

// Holds the compiler's `Project`, captured in the component registrar's
// `registerProjectComponents`. The K2/FIR comment extractor
// (`CommentExtractorLighterAST`) needs it to build a `KtPsiFactory` and parse
// KDoc section structure, which is not present in the FIR lighter AST (the KDOC
// node is a leaf there). Under K1 the PSI-based extractor is used instead and
// this holder is not consulted.
//
// A weak reference is used so this process-global does not keep a disposed
// project alive; callers must tolerate a null/disposed project (sections are
// then omitted, matching the pre-existing behaviour).
object KDocProjectHolder {
    private var ref: WeakReference<Project>? = null

    var project: Project?
        get() = ref?.get()?.takeUnless { it.isDisposed }
        set(value) {
            ref = value?.let { WeakReference(it) }
        }
}
