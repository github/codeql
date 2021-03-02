/*
 * Copyright (C) 2008 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.common.collect;

import java.io.Serializable;
import java.util.AbstractCollection;
import java.util.Collection;
import java.util.Iterator;

public abstract class ImmutableCollection<E> extends AbstractCollection<E> implements Serializable {
  ImmutableCollection() {}
  
  public ImmutableList<E> asList() {
    return null;
  }

  public abstract static class Builder<E> {
    Builder() {}

    public abstract Builder<E> add(E element);

    public Builder<E> add(E... elements) {
      return null;
    }

    public Builder<E> addAll(Iterable<? extends E> elements) {
      return null;
    }

    public Builder<E> addAll(Iterator<? extends E> elements) {
      return null;
    }

    public abstract ImmutableCollection<E> build();
  }
}
