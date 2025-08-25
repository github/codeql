package extlib;

import java.util.*;

public class Lib {

  public void testParameterTypes(
    char p1,
    byte p2,
    short p3,
    int p4,
    long p5,
    float p6,
    double p7,
    boolean p8,
    Lib simpleClass,
    GenericTest<String> simpleGeneric,
    BoundedGenericTest<String> boundedGeneric,
    ComplexBoundedGenericTest<CharSequence, String> complexBoundedGeneric,
    int[] primitiveArray,
    Integer[] boxedTypeArray,
    int [][] multiDimensionalPrimitiveArray,
    Integer[][] multiDimensionalBoxedTypeArray,
    List<String>[] genericTypeArray,
    List<? extends CharSequence> producerWildcard,
    List<? super CharSequence> consumerWildcard,
    List<? extends List<? extends CharSequence>> nestedWildcard,
    List<?> unboundedWildcard) { }

  public List<Integer> returnErasureTest() { return null; }

  public <T> void paramErasureTest(List<String> param) { }

}

