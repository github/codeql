import extlib.*;

public class JavaUser {

  public static void test() {

    OuterGeneric<Integer>.InnerGeneric<String> a = (new OuterGeneric<Integer>()).new InnerGeneric<String>('a');
    OuterGeneric<Integer>.InnerGeneric<String> a2 = (new OuterGeneric<Integer>()).new <Character> InnerGeneric<String>('a');
    OuterGeneric<Integer>.InnerGeneric<String> a3 = (new OuterGeneric<Integer>()).new <Character> InnerGeneric<String>('a', "Hello world");
    OuterGeneric<Integer>.InnerNotGeneric b = (new OuterGeneric<Integer>()).new InnerNotGeneric();
    OuterGeneric<String>.InnerNotGeneric b2 = (new OuterGeneric<String>()).new InnerNotGeneric();
    OuterNotGeneric.InnerGeneric<String> c = (new OuterNotGeneric()).new InnerGeneric<String>();
    OuterGeneric.InnerStaticGeneric<String> d = new OuterGeneric.InnerStaticGeneric<String>('a', "Hello world");
    OuterManyParams<Integer, String>.MiddleManyParams<Float, Double>.InnerManyParams<Long, Short> e = ((new OuterManyParams<Integer, String>(1, "hello")).new MiddleManyParams<Float, Double>(1.0f, 1.0)).new InnerManyParams<Long, Short>(1L, (short)1);

    String result1 = a.returnsecond(0, "hello");
    String result1a = a.returnsecond(0, "hello", 'a');
    Integer result2 = b.identity(5);
    String result2b = b2.identity("hello");
    String result3 = c.identity("world");
    String result4 = d.identity("goodbye");
    Short result5 = e.returnSixth(1, "hello", 1.0f, 1.0, 1L, (short)1);

    OuterGeneric<String>.InnerNotGeneric innerGetterTest = (new OuterGeneric<String>()).getInnerNotGeneric();
    OuterNotGeneric.InnerGeneric<String> innerGetterTest2 = (new OuterNotGeneric()).getInnerGeneric();

    TypeParamVisibility<String> tpv = new TypeParamVisibility<String>();
    TypeParamVisibility<String>.VisibleBecauseInner<String> visibleBecauseInner = tpv.getVisibleBecauseInner();
    TypeParamVisibility<String>.VisibleBecauseInnerIndirectContainer.VisibleBecauseInnerIndirect<String> visibleBecauseInnerIndirect = tpv.getVisibleBecauseInnerIndirect();
    TypeParamVisibility.NotVisibleBecauseStatic<String> notVisibleBecauseStatic = tpv.getNotVisibleBecauseStatic();
    TypeParamVisibility.NotVisibleBecauseStaticIndirectContainer.NotVisibleBecauseStaticIndirect<String> notVisibleBecauseStaticIndirect = tpv.getNotVisibleBecauseStaticIndirect();

  }

}
