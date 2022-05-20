// Generated automatically from com.google.common.base.Equivalence for testing purposes

package com.google.common.base;

import com.google.common.base.Function;
import com.google.common.base.Predicate;
import java.io.Serializable;
import java.util.function.BiPredicate;

abstract public class Equivalence<T> implements BiPredicate<T, T>
{
    protected Equivalence(){}
    protected abstract boolean doEquivalent(T p0, T p1);
    protected abstract int doHash(T p0);
    public final <F> Equivalence<F> onResultOf(Function<F, ? extends T> p0){ return null; }
    public final <S extends T> Equivalence.Wrapper<S> wrap(S p0){ return null; }
    public final <S extends T> Equivalence<Iterable<S>> pairwise(){ return null; }
    public final Predicate<T> equivalentTo(T p0){ return null; }
    public final boolean equivalent(T p0, T p1){ return false; }
    public final boolean test(T p0, T p1){ return false; }
    public final int hash(T p0){ return 0; }
    public static Equivalence<Object> equals(){ return null; }
    public static Equivalence<Object> identity(){ return null; }
    static public class Wrapper<T> implements Serializable
    {
        protected Wrapper() {}
        public String toString(){ return null; }
        public T get(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
    }
}
