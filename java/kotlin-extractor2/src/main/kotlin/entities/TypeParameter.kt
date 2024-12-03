package com.github.codeql.entities

import com.github.codeql.*
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaTypeParameterSymbol
import org.jetbrains.kotlin.analysis.api.symbols.psiSafe
import org.jetbrains.kotlin.analysis.api.types.KaTypeParameterType
import org.jetbrains.kotlin.types.Variance

context(KaSession)
fun KotlinUsesExtractor.getTypeParameterLabel(param: KaTypeParameterSymbol): String {
    // Use this instead of `useDeclarationParent` so we can use useFunction with noReplace = true,
    // ensuring that e.g. a method-scoped type variable declared on kotlin.String.transform<R> gets
    // a different name to the corresponding java.lang.String.transform<R>, even though
    // useFunction will usually replace references to one function with the other.
    val parentLabel = getTypeParameterParentLabel(param)
    return "@\"typevar;{$parentLabel};${param.name}\""
}

context(KaSession)
fun KotlinFileExtractor.extractTypeParameter(
    tp: KaTypeParameterSymbol,
    apparentIndex: Int,
    /* OLD: KE1
    javaTypeParameter: JavaTypeParameter? */
): Label<out DbTypevariable>? {
    with("type parameter", tp) {
        val parentId = getTypeParameterParentLabel(tp) ?: return null
        val id = tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(tp))

        /* COMMENT OLD: KE1 -- check if this still applies */
        // Note apparentIndex does not necessarily equal `tp.index`, because at least constructor type parameters
        // have indices offset from the type parameters of the constructed class (i.e. the parameter S of
        // `class Generic<T> { public <S> Generic(T t, S s) { ... } }` will have `tp.index` 1, not 0).
        tw.writeTypeVars(id, tp.name.asString(), apparentIndex, parentId)
        val locId = tp.psiSafe<PsiElement>()?.let { tw.getLocation(it) } ?: tw.getWholeFileLocation()
        tw.writeHasLocation(id, locId)

        /* OLD: KE1
        // Annoyingly, we have no obvious way to pair up the bounds of an IrTypeParameter and a  JavaTypeParameter
        // because JavaTypeParameter provides a Collection not an ordered list, so we can only do our best here:
        fun tryGetJavaBound(idx: Int) =
            when (tp.superTypes.size) {
                1 -> javaTypeParameter?.upperBounds?.singleOrNull()
                else -> (javaTypeParameter?.upperBounds as? List)?.getOrNull(idx)
            }
         */

        tp.upperBounds.forEachIndexed { boundIdx, bound ->
            if (!bound.upperBoundIfFlexible().isAnyType) {
                tw.getLabelFor<DbTypebound>("@\"bound;$boundIdx;{$id}\"") {
                    /* COMMENT OLD: KE1 -- check if this still applies */
                    // Note we don't look for @JvmSuppressWildcards here because it doesn't seem to have any impact
                    // on kotlinc adding wildcards to type parameter bounds.
                    val boundWithWildcards = bound
                    /* OLD: KE1
                        addJavaLoweringWildcards(bound, true, tryGetJavaBound(tp.index))
                     */
                    tw.writeTypeBounds(
                        it,
                        useType(boundWithWildcards).javaResult.id.cast<DbReftype>(),
                        boundIdx,
                        id
                    )
                }
            }
        }

        if (tp.isReified) {
            addModifiers(id, "reified")
        }

        when (tp.variance) {
            Variance.IN_VARIANCE -> addModifiers(id, "in")
            Variance.OUT_VARIANCE -> addModifiers(id, "out")
            else -> {}
        }

        // extractAnnotations(tp, id)
        // TODO: introduce annotations once they can be disambiguated from bounds, which are
        // also child expressions.
        return id
    }
}
