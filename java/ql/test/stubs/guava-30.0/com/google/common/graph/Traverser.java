/*
 * Copyright (C) 2017 The Guava Authors
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

package com.google.common.graph;

public abstract class Traverser<N> {
  public static <N> Traverser<N> forGraph(final SuccessorsFunction<N> graph) {
    return null;
  }

  public static <N> Traverser<N> forTree(final SuccessorsFunction<N> tree) {
    return null;
  }

  public final Iterable<N> breadthFirst(N startNode) {
    return null;
  }

  public final Iterable<N> breadthFirst(Iterable<? extends N> startNodes) {
    return null;
  }

  public final Iterable<N> depthFirstPreOrder(N startNode) {
    return null;
  }

  public final Iterable<N> depthFirstPreOrder(Iterable<? extends N> startNodes) {
    return null;
  }

  public final Iterable<N> depthFirstPostOrder(N startNode) {
    return null;
  }

  public final Iterable<N> depthFirstPostOrder(Iterable<? extends N> startNodes) {
    return null;
  }

}
