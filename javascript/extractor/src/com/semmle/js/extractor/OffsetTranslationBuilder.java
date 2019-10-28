package com.semmle.js.extractor;

import com.semmle.util.data.IntList;

/**
 * A mapping from integers to integers, is encoded as a sequence of consecutive intervals and their
 * corresponding output intervals.
 */
public class OffsetTranslationBuilder {
  private IntList anchors = IntList.create();
  private IntList deltas = IntList.create();

  /** Returns the mapping of x. */
  public int get(int x) {
    int index = anchors.binarySearch(x);
    if (index < 0) {
      // The insertion point is -index - 1.
      // Get the index immediately before that.
      index = -index - 2;
      if (index < 0) {
        // If queried before the first anchor, use the first anchor anyway.
        index = 0;
      }
    }
    return x + deltas.get(index);
  }

  /**
   * Maps the given input offset to the given output offset.
   *
   * <p>This is added as an anchor. Any offset is mapped based on its closest preceding anchor.
   */
  public void set(int from, int to) {
    anchors.add(from);
    deltas.add(to - from);
  }
}
