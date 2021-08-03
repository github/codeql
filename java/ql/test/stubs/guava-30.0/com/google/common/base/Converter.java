// Generated automatically from com.google.common.base.Converter for testing purposes

package com.google.common.base;

import com.google.common.base.Function;

abstract public class Converter<A, B> implements Function<A, B>
{
    protected Converter(){}
    protected abstract A doBackward(B p0);
    protected abstract B doForward(A p0);
    public Converter<B, A> reverse(){ return null; }
    public Iterable<B> convertAll(Iterable<? extends A> p0){ return null; }
    public boolean equals(Object p0){ return false; }
    public final <C> Converter<A, C> andThen(Converter<B, C> p0){ return null; }
    public final B apply(A p0){ return null; }
    public final B convert(A p0){ return null; }
    public static <A, B> Converter<A, B> from(Function<? super A, ? extends B> p0, Function<? super B, ? extends A> p1){ return null; }
    public static <T> Converter<T, T> identity(){ return null; }
}
