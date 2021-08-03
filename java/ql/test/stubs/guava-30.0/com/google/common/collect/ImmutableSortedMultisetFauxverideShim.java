// Generated automatically from com.google.common.collect.ImmutableSortedMultisetFauxverideShim for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableMultiset;
import com.google.common.collect.ImmutableSortedMultiset;
import java.util.function.Function;
import java.util.function.ToIntFunction;
import java.util.stream.Collector;

abstract class ImmutableSortedMultisetFauxverideShim<E> extends ImmutableMultiset<E>
{
    public static <E> Collector<E, ? extends Object, ImmutableMultiset<E>> toImmutableMultiset(){ return null; }
    public static <E> ImmutableSortedMultiset.Builder<E> builder(){ return null; }
    public static <E> ImmutableSortedMultiset<E> copyOf(E[] p0){ return null; }
    public static <E> ImmutableSortedMultiset<E> of(E p0){ return null; }
    public static <E> ImmutableSortedMultiset<E> of(E p0, E p1){ return null; }
    public static <E> ImmutableSortedMultiset<E> of(E p0, E p1, E p2){ return null; }
    public static <E> ImmutableSortedMultiset<E> of(E p0, E p1, E p2, E p3){ return null; }
    public static <E> ImmutableSortedMultiset<E> of(E p0, E p1, E p2, E p3, E p4){ return null; }
    public static <E> ImmutableSortedMultiset<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E... p6){ return null; }
    public static <T, E> Collector<T, ? extends Object, ImmutableMultiset<E>> toImmutableMultiset(Function<? super T, ? extends E> p0, ToIntFunction<? super T> p1){ return null; }
}
