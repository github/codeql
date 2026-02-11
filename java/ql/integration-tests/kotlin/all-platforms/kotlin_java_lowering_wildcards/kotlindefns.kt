// Note throughout, using:
// MutableList as a type whose parameter is invariant
// List as a type whose parameter is covariant (List<out T>)
// Comparable as a type whose parameter is contravariant (Comparable<int T>)
// CharSequence as a non-final type
// String as a final type

class ComparableCs : Comparable<CharSequence> {
  override fun compareTo(other: CharSequence): Int = 1
}

class KotlinDefns {

  fun takesInvariantType(noUseSiteVariance: MutableList<CharSequence>, useSiteCovariant: MutableList<out CharSequence>, useSiteContravariant: MutableList<in CharSequence>) { }

  // Note List<in CharSequence> is a static error (contradictory variance)
  fun takesCovariantType(noUseSiteVariance: List<CharSequence>, useSiteCovariant: List<out CharSequence>) { }

  // Note Comparable<out CharSequence> is a static error (contradictory variance)
  fun takesContravariantType(noUseSiteVariance: Comparable<CharSequence>, useSiteContravariant: Comparable<in CharSequence>) { }

  fun takesNestedType(invar: MutableList<MutableList<CharSequence>>, covar: List<List<CharSequence>>, contravar: Comparable<Comparable<CharSequence>>, mixed1: List<Comparable<CharSequence>>, mixed2: Comparable<List<CharSequence>>) { }

  fun takesFinalParameter(invar: MutableList<String>, covar: List<String>, contravar: Comparable<String>) { }

  fun takesFinalParameterForceWildcard(invar: MutableList<@JvmWildcard String>, covar: List<@JvmWildcard String>, contravar: Comparable<@JvmWildcard String>) { }

  fun takesAnyParameter(invar: MutableList<Any>, covar: List<Any>, contravar: Comparable<Any>) { }

  fun takesAnyQParameter(invar: MutableList<Any?>, covar: List<Any?>, contravar: Comparable<Any?>) { }

  fun takesAnyParameterForceWildcard(invar: MutableList<@JvmWildcard Any>, covar: List<@JvmWildcard Any>, contravar: Comparable<@JvmWildcard Any>) { }

  fun takesVariantTypesSuppressedWildcards(covar: List<@JvmSuppressWildcards CharSequence>, contravar: Comparable<@JvmSuppressWildcards CharSequence>) { }

  fun takesVariantTypesIndirectlySuppressedWildcards(covar: @JvmSuppressWildcards List<CharSequence>, contravar: @JvmSuppressWildcards Comparable<CharSequence>) { }

  fun takesVariantTypesComplexSuppressionWildcards(covar: @JvmSuppressWildcards(suppress = true) List<@JvmSuppressWildcards List<@JvmSuppressWildcards(suppress = false) List<CharSequence>>>) { }

  fun returnsInvar() : MutableList<CharSequence> = mutableListOf()

  fun returnsCovar(): List<CharSequence> = listOf()

  fun returnsContravar(): Comparable<CharSequence> = ComparableCs()

  fun returnsCovarForced(): List<@JvmWildcard CharSequence> = listOf()

  fun returnsContravarForced(): Comparable<@JvmWildcard CharSequence> = ComparableCs()

}

@JvmSuppressWildcards
class KotlinDefnsSuppressedOuter {

  fun outerFn(covar: List<CharSequence>, contravar: Comparable<CharSequence>) { }

  class Inner {

    fun innerFn(covar: List<CharSequence>, contravar: Comparable<CharSequence>) { }

  }

}

class KotlinDefnsSuppressedInner {

  fun outerFn(covar: List<CharSequence>, contravar: Comparable<CharSequence>) { }

  @JvmSuppressWildcards
  class Inner {

    fun innerFn(covar: List<CharSequence>, contravar: Comparable<CharSequence>) { }

  }

}

class KotlinDefnsSuppressedFn {

  @JvmSuppressWildcards fun outerFn(covar: List<CharSequence>, contravar: Comparable<CharSequence>) { }

}
