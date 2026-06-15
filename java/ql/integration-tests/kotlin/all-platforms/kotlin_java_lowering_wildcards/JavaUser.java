import java.util.List;

public class JavaUser {

  public static void test() {

    KotlinDefns kd = new KotlinDefns();

    kd.takesInvariantType((List<CharSequence>)null, (List<? extends CharSequence>)null, (List<? super CharSequence>)null);

    kd.takesCovariantType((List<? extends CharSequence>)null, (List<? extends CharSequence>)null);

    kd.takesContravariantType((Comparable<? super CharSequence>)null, (Comparable<? super CharSequence>)null);

    kd.takesNestedType((List<List<CharSequence>>) null, (List<? extends List<? extends CharSequence>>)null, (Comparable<? super Comparable<? super CharSequence>>)null, (List<? extends Comparable<? super CharSequence>>)null, (Comparable<? super List<? extends CharSequence>>)null);

    kd.takesFinalParameter((List<String>)null, (List<String>)null, (Comparable<? super String>)null);

    kd.takesFinalParameterForceWildcard((List<String>)null, (List<? extends String>)null, (Comparable<? super String>)null);

    kd.takesAnyParameter((List<Object>)null, (List<? extends Object>)null, (Comparable<Object>)null);

    kd.takesAnyQParameter((List<Object>)null, (List<? extends Object>)null, (Comparable<Object>)null);

    kd.takesAnyParameterForceWildcard((List<Object>)null, (List<? extends Object>)null, (Comparable<? super Object>)null);

    kd.takesVariantTypesSuppressedWildcards((List<CharSequence>)null, (Comparable<CharSequence>)null);

    List<CharSequence> r1 = kd.returnsInvar();

    List<CharSequence> r2 = kd.returnsCovar();

    Comparable<CharSequence> r3 = kd.returnsContravar();

    List<? extends CharSequence> r4 = kd.returnsCovarForced();

    Comparable<? super CharSequence> r5 = kd.returnsContravarForced();

    KotlinDefnsSuppressedOuter kdso = new KotlinDefnsSuppressedOuter();
    kdso.outerFn((List<CharSequence>)null, (Comparable<CharSequence>)null);
    KotlinDefnsSuppressedOuter.Inner kdsoi = new KotlinDefnsSuppressedOuter.Inner();
    kdsoi.innerFn((List<CharSequence>)null, (Comparable<CharSequence>)null);

    KotlinDefnsSuppressedInner kdsi = new KotlinDefnsSuppressedInner();
    kdsi.outerFn((List<? extends CharSequence>)null, (Comparable<? super CharSequence>)null);
    KotlinDefnsSuppressedInner.Inner kdsii = new KotlinDefnsSuppressedInner.Inner();
    kdsii.innerFn((List<CharSequence>)null, (Comparable<CharSequence>)null);

    KotlinDefnsSuppressedFn kdsf = new KotlinDefnsSuppressedFn();
    kdsf.outerFn((List<CharSequence>)null, (Comparable<CharSequence>)null);

    kd.takesVariantTypesIndirectlySuppressedWildcards((List<CharSequence>)null, (Comparable<CharSequence>)null);
    kd.takesVariantTypesComplexSuppressionWildcards((List<List<? extends List<? extends CharSequence>>>)null);

  }

}
