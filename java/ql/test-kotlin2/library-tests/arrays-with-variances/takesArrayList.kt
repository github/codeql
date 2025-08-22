public class TakesArrayList {

  // There is a Java user to flag up any problems, as if the .class file differs from my
  // claimed types above we'll see two overloads and two parameter types instead of one.

  // Test how Array types with a variance should be lowered:
  fun invarArray(a: Array<CharSequence>) { }
  fun outArray(a: Array<out CharSequence>) { }
  fun inArray(a: Array<in CharSequence>) { }

  fun invarInvarArray(a: Array<Array<CharSequence>>) { }
  fun invarOutArray(a: Array<Array<out CharSequence>>) { }
  fun invarInArray(a: Array<Array<in CharSequence>>) { }

  fun outInvarArray(a: Array<out Array<CharSequence>>) { }
  fun outOutArray(a: Array<out Array<out CharSequence>>) { }
  fun outInArray(a: Array<out Array<in CharSequence>>) { }

  fun inInvarArray(a: Array<in Array<CharSequence>>) { }
  fun inOutArray(a: Array<in Array<out CharSequence>>) { }
  fun inInArray(a: Array<in Array<in CharSequence>>) { }

  // Test how Array type arguments with a variance should acquire implicit wildcards:
  fun invarArrayList(l: List<Array<CharSequence>>) { }
  fun outArrayList(l: List<Array<out CharSequence>>) { }
  fun inArrayList(l: List<Array<in CharSequence>>) { }

  // Check the cases of nested arrays:
  fun invarInvarArrayList(l: List<Array<Array<CharSequence>>>) { }
  fun invarOutArrayList(l: List<Array<Array<out CharSequence>>>) { }
  fun invarInArrayList(l: List<Array<Array<in CharSequence>>>) { }
  fun outInvarArrayList(l: List<Array<out Array<CharSequence>>>) { }
  fun outOutArrayList(l: List<Array<out Array<out CharSequence>>>) { }
  fun outInArrayList(l: List<Array<out Array<in CharSequence>>>) { }
  fun inInvarArrayList(l: List<Array<in Array<CharSequence>>>) { }
  fun inOutArrayList(l: List<Array<in Array<out CharSequence>>>) { }
  fun inInArrayList(l: List<Array<in Array<in CharSequence>>>) { }

  // Now check all of that again for Comparable, whose type parameter is contravariant:
  fun invarArrayComparable(c: Comparable<Array<CharSequence>>) { }
  fun outArrayComparable(c: Comparable<Array<out CharSequence>>) { }
  fun inArrayComparable(c: Comparable<Array<in CharSequence>>) { }

  fun invarInvarArrayComparable(c: Comparable<Array<Array<CharSequence>>>) { }
  fun invarOutArrayComparable(c: Comparable<Array<Array<out CharSequence>>>) { }
  fun invarInArrayComparable(c: Comparable<Array<Array<in CharSequence>>>) { }
  fun outInvarArrayComparable(c: Comparable<Array<out Array<CharSequence>>>) { }
  fun outOutArrayComparable(c: Comparable<Array<out Array<out CharSequence>>>) { }
  fun outInArrayComparable(c: Comparable<Array<out Array<in CharSequence>>>) { }
  fun inInvarArrayComparable(c: Comparable<Array<in Array<CharSequence>>>) { }
  fun inOutArrayComparable(c: Comparable<Array<in Array<out CharSequence>>>) { }
  fun inInArrayComparable(c: Comparable<Array<in Array<in CharSequence>>>) { }

  // ... duplicate all of that for a final array element (I choose String as a final type), which sometimes suppresses addition of `? extends ...`
  fun invarArrayListFinal(l: List<Array<String>>) { }
  fun outArrayListFinal(l: List<Array<out String>>) { }
  fun inArrayListFinal(l: List<Array<in String>>) { }

  fun invarInvarArrayListFinal(l: List<Array<Array<String>>>) { }
  fun invarOutArrayListFinal(l: List<Array<Array<out String>>>) { }
  fun invarInArrayListFinal(l: List<Array<Array<in String>>>) { }
  fun outInvarArrayListFinal(l: List<Array<out Array<String>>>) { }
  fun outOutArrayListFinal(l: List<Array<out Array<out String>>>) { }
  fun outInArrayListFinal(l: List<Array<out Array<in String>>>) { }
  fun inInvarArrayListFinal(l: List<Array<in Array<String>>>) { }
  fun inOutArrayListFinal(l: List<Array<in Array<out String>>>) { }
  fun inInArrayListFinal(l: List<Array<in Array<in String>>>) { }

  fun invarArrayComparableFinal(c: Comparable<Array<String>>) { }
  fun outArrayComparableFinal(c: Comparable<Array<out String>>) { }
  fun inArrayComparableFinal(c: Comparable<Array<in String>>) { }

  fun invarInvarArrayComparableFinal(c: Comparable<Array<Array<String>>>) { }
  fun invarOutArrayComparableFinal(c: Comparable<Array<Array<out String>>>) { }
  fun invarInArrayComparableFinal(c: Comparable<Array<Array<in String>>>) { }
  fun outInvarArrayComparableFinal(c: Comparable<Array<out Array<String>>>) { }
  fun outOutArrayComparableFinal(c: Comparable<Array<out Array<out String>>>) { }
  fun outInArrayComparableFinal(c: Comparable<Array<out Array<in String>>>) { }
  fun inInvarArrayComparableFinal(c: Comparable<Array<in Array<String>>>) { }
  fun inOutArrayComparableFinal(c: Comparable<Array<in Array<out String>>>) { }
  fun inInArrayComparableFinal(c: Comparable<Array<in Array<in String>>>) { }

  // ... and duplicate it once more with Any as the array element, which can suppress adding `? super ...`
  fun invarArrayListAny(l: List<Array<Any>>) { }
  fun outArrayListAny(l: List<Array<out Any>>) { }
  fun inArrayListAny(l: List<Array<in Any>>) { }

  fun invarInvarArrayListAny(l: List<Array<Array<Any>>>) { }
  fun invarOutArrayListAny(l: List<Array<Array<out Any>>>) { }
  fun invarInArrayListAny(l: List<Array<Array<in Any>>>) { }
  fun outInvarArrayListAny(l: List<Array<out Array<Any>>>) { }
  fun outOutArrayListAny(l: List<Array<out Array<out Any>>>) { }
  fun outInArrayListAny(l: List<Array<out Array<in Any>>>) { }
  fun inInvarArrayListAny(l: List<Array<in Array<Any>>>) { }
  fun inOutArrayListAny(l: List<Array<in Array<out Any>>>) { }
  fun inInArrayListAny(l: List<Array<in Array<in Any>>>) { }

  fun invarArrayComparableAny(c: Comparable<Array<Any>>) { }
  fun outArrayComparableAny(c: Comparable<Array<out Any>>) { }
  fun inArrayComparableAny(c: Comparable<Array<in Any>>) { }

  fun invarInvarArrayComparableAny(c: Comparable<Array<Array<Any>>>) { }
  fun invarOutArrayComparableAny(c: Comparable<Array<Array<out Any>>>) { }
  fun invarInArrayComparableAny(c: Comparable<Array<Array<in Any>>>) { }
  fun outInvarArrayComparableAny(c: Comparable<Array<out Array<Any>>>) { }
  fun outOutArrayComparableAny(c: Comparable<Array<out Array<out Any>>>) { }
  fun outInArrayComparableAny(c: Comparable<Array<out Array<in Any>>>) { }
  fun inInvarArrayComparableAny(c: Comparable<Array<in Array<Any>>>) { }
  fun inOutArrayComparableAny(c: Comparable<Array<in Array<out Any>>>) { }
  fun inInArrayComparableAny(c: Comparable<Array<in Array<in Any>>>) { }

}
