public class JavaDefns {

  // Currently known not to work: the Comparable<? extends X> case, which Kotlin sees as Comparable<*> because the
  // wildcard goes the opposite direction to the variance declared on Comparable's type parameter.

  public static void takesComparable(Comparable<CharSequence> invar, Comparable<? super CharSequence> contravar) { }

  public static void takesNestedComparable(Comparable<Comparable<? super CharSequence>> innerContravar, Comparable<? super Comparable<CharSequence>> outerContravar) { }

  public static void takesArrayOfComparable(Comparable<CharSequence>[] invar, Comparable<? super CharSequence>[] contravar) { }

  public static Comparable<? super CharSequence> returnsWildcard() { return null; }

  public static Comparable<CharSequence> returnsInvariant() { return null; }

  public JavaDefns(Comparable<CharSequence> invar, Comparable<? super CharSequence> contravar) { }

}
