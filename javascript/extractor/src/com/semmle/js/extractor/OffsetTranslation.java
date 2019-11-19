package com.semmle.js.extractor;

import com.semmle.util.data.IntList;

/**
 * A mapping of some source range into a set of intervals in an output source range.
 *
 * <p>The mapping is constructed by adding "anchors": input/output pairs that correspond to the
 * beginning of an interval, which is assumed to end at the next anchor.
 */
public class OffsetTranslation {
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
