/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.commons.lang3.tuple;

/**
 * <p>An immutable triple consisting of three {@code Object} elements.</p>
 *
 * <p>Although the implementation is immutable, there is no restriction on the objects
 * that may be stored. If mutable objects are stored in the triple, then the triple
 * itself effectively becomes mutable. The class is also {@code final}, so a subclass
 * can not add undesirable behavior.</p>
 *
 * <p>#ThreadSafe# if all three objects are thread-safe</p>
 *
 * @param <L> the left element type
 * @param <M> the middle element type
 * @param <R> the right element type
 *
 * @since 3.2
 */
public final class ImmutableTriple<L, M, R> extends Triple<L, M, R> {

    /**
     * An empty array.
     * <p>
     * Consider using {@link #emptyArray()} to avoid generics warnings.
     * </p>
     *
     * @since 3.10.
     */
    public static final ImmutableTriple<?, ?, ?>[] EMPTY_ARRAY = null;

    /**
     * Returns the empty array singleton that can be assigned without compiler warning.
     *
     * @param <L> the left element type
     * @param <M> the middle element type
     * @param <R> the right element type
     * @return the empty array singleton that can be assigned without compiler warning.
     *
     * @since 3.10.
     */
    @SuppressWarnings("unchecked")
    public static <L, M, R> ImmutableTriple<L, M, R>[] emptyArray() {
        return null;
    }

    /**
     * Returns an immutable triple of nulls.
     *
     * @param <L> the left element of this triple. Value is {@code null}.
     * @param <M> the middle element of this triple. Value is {@code null}.
     * @param <R> the right element of this triple. Value is {@code null}.
     * @return an immutable triple of nulls.
     * @since 3.6
     */
    public static <L, M, R> ImmutableTriple<L, M, R> nullTriple() {
        return null;
    }

    /**
     * <p>Obtains an immutable triple of three objects inferring the generic types.</p>
     *
     * <p>This factory allows the triple to be created using inference to
     * obtain the generic types.</p>
     *
     * @param <L> the left element type
     * @param <M> the middle element type
     * @param <R> the right element type
     * @param left  the left element, may be null
     * @param middle  the middle element, may be null
     * @param right  the right element, may be null
     * @return a triple formed from the three parameters, not null
     */
    public static <L, M, R> ImmutableTriple<L, M, R> of(final L left, final M middle, final R right) {
        return null;
    }
    /** Left object */
    public final L left;
    /** Middle object */
    public final M middle;

    /** Right object */
    public final R right;

    /**
     * Create a new triple instance.
     *
     * @param left  the left value, may be null
     * @param middle the middle value, may be null
     * @param right  the right value, may be null
     */
    public ImmutableTriple(final L left, final M middle, final R right) {
        this.left = null;
        this.middle = null;
        this.right = null;
    }

    //-----------------------------------------------------------------------
    /**
     * {@inheritDoc}
     */
    @Override
    public L getLeft() {
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public M getMiddle() {
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public R getRight() {
        return null;
    }
}