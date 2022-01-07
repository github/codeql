// Generated automatically from com.google.common.collect.DiscreteDomain for testing purposes

package com.google.common.collect;

import java.math.BigInteger;

abstract public class DiscreteDomain<C extends Comparable>
{
    protected DiscreteDomain(){}
    public C maxValue(){ return null; }
    public C minValue(){ return null; }
    public abstract C next(C p0);
    public abstract C previous(C p0);
    public abstract long distance(C p0, C p1);
    public static DiscreteDomain<BigInteger> bigIntegers(){ return null; }
    public static DiscreteDomain<Integer> integers(){ return null; }
    public static DiscreteDomain<Long> longs(){ return null; }
}
