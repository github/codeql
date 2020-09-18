/*
 * Copyright (C) Lightbend Inc. <https://www.lightbend.com>
 */

package play.libs.typedmap;

import play.libs.typedmap.TypedKey;

import java.util.Optional;

/**
 * A TypedMap is an immutable map containing typed values. Each entry is associated with a {@link
 * TypedKey} that can be used to look up the value. A <code>TypedKey</code> also defines the type of
 * the value, e.g. a <code>TypedKey&lt;String&gt;</code> would be associated with a <code>String
 * </code> value.
 *
 * <p>Instances of this class are created with the {@link #empty()} method.
 *
 * <p>The elements inside TypedMaps cannot be enumerated. This is a decision designed to enforce
 * modularity. It's not possible to accidentally or intentionally access a value in a TypedMap
 * without holding the corresponding {@link TypedKey}.
 */
public final class TypedMap {

}