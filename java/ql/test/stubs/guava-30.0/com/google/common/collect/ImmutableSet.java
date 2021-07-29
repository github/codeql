// Generated automatically from com.google.common.collect.ImmutableSet for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.UnmodifiableIterator;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.stream.Collector;

abstract public class ImmutableSet<E> extends ImmutableCollection<E> implements Set<E>
{
    ImmutableList<E> createAsList(){ return null; }
    ImmutableSet(){}
    Object writeReplace(){ return null; }
    boolean isHashCodeFast(){ return false; }
    public ImmutableList<E> asList(){ return null; }
    public abstract UnmodifiableIterator<E> iterator();
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static <E> Collector<E, ? extends Object, ImmutableSet<E>> toImmutableSet(){ return null; }
    public static <E> ImmutableSet.Builder<E> builder(){ return null; }
    public static <E> ImmutableSet.Builder<E> builderWithExpectedSize(int p0){ return null; }
    public static <E> ImmutableSet<E> copyOf(Collection<? extends E> p0){ return null; }
    public static <E> ImmutableSet<E> copyOf(E[] p0){ return null; }
    public static <E> ImmutableSet<E> copyOf(Iterable<? extends E> p0){ return null; }
    public static <E> ImmutableSet<E> copyOf(Iterator<? extends E> p0){ return null; }
    public static <E> ImmutableSet<E> of(){ return null; }
    public static <E> ImmutableSet<E> of(E p0){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1, E p2){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1, E p2, E p3){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1, E p2, E p3, E p4){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E... p6){ return null; }
    static Object[] rebuildHashTable(int p0, Object[] p1, int p2){ return null; }
    static boolean hashFloodingDetected(Object[] p0){ return false; }
    static double HASH_FLOODING_FPP = 0;
    static int MAX_RUN_MULTIPLIER = 0;
    static int MAX_TABLE_SIZE = 0;
    static int SPLITERATOR_CHARACTERISTICS = 0;
    static int chooseTableSize(int p0){ return 0; }
    static public class Builder<E> extends ImmutableCollection.Builder<E>
    {
        Builder(boolean p0){}
        Builder(int p0){}
        ImmutableSet.Builder<E> combine(ImmutableSet.Builder<E> p0){ return null; }
        boolean forceCopy = false;
        final void copyIfNecessary(){}
        public Builder(){}
        public ImmutableSet.Builder<E> add(E p0){ return null; }
        public ImmutableSet.Builder<E> add(E... p0){ return null; }
        public ImmutableSet.Builder<E> addAll(Iterable<? extends E> p0){ return null; }
        public ImmutableSet.Builder<E> addAll(Iterator<? extends E> p0){ return null; }
        public ImmutableSet<E> build(){ return null; }
        void copy(){}
        void forceJdk(){}
    }
}
