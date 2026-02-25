overlay[local]
module;

private import minimal.minimal
private import JSUnified
private import DataFlowBuilder
private import Contents

private module Raw {
  newtype TTransform =
    ToPromise() or
    AwaitValue() or
    ReadIterableContents() or
    ReadAsyncIterableContents() or
    ToAsyncIteratorElement() or
    ShiftArrayElements(int amount) { amount = [-10 .. 10] } or
    ToArray()
}

class TransformBase = Raw::TTransform;

private class ToPromise extends Transform, Raw::ToPromise {
  override string toString() { result = "ToPromise" }

  override predicate step(string node1, Step step, string node2) {
    node1 = "input" and step.withoutContent(anyPromiseContent()) and node2 = "mid"
    or
    node1 = "mid" and step.store(promiseValue()) and node2 = "output"
    or
    node1 = "input" and step.withContent(anyPromiseContent()) and node2 = "output"
  }
}

private class AwaitValue extends Transform, Raw::AwaitValue {
  override string toString() { result = "AwaitValue" }

  override predicate step(string node1, Step step, string node2) {
    node1 = "input" and step.withoutContent(anyPromiseContent()) and node2 = "output"
    or
    node1 = "input" and step.read(promiseValue()) and node2 = "output"
  }
}

private class ReadIterableContents extends Transform, Raw::ReadIterableContents {
  override string toString() { result = "ReadIterableContents" }

  override predicate step(string node1, Step step, string node2) {
    node1 = "input" and step.read(ArrayContent::anyElement()) and node2 = "output"
    or
    node1 = "input" and step.read(Contents::iteratorElement()) and node2 = "output"
    or
    node1 = "input" and step.read(MapContent::key()) and node2 = "map-key"
    or
    node1 = "map-key" and step.store(ArrayContent::elementAt(0)) and node2 = "output"
    or
    node1 = "input" and step.read(MapContent::value()) and node2 = "map-value"
    or
    node1 = "map-value" and
    step.store(ArrayContent::elementAt(1)) and
    node2 = "output"
    or
    node1 = "input" and step.taint() and node2 = "output"
  }
}

private class ReadAsyncIterableContents extends Transform, Raw::ReadAsyncIterableContents {
  override string toString() { result = "ReadAsyncIterableContents" }

  override predicate step(string node1, Step step, string node2) {
    node1 = "input" and step.transform(Transforms::readIterableContents()) and node2 = "value"
    or
    node1 = "value" and step.transform(Transforms::awaitValue()) and node2 = "output"
  }
}

private class ToAsyncIteratorElement extends Transform, Raw::ToAsyncIteratorElement {
  override string toString() { result = "ToAsyncIteratorElement" }

  override predicate step(string node1, Step step, string node2) {
    node1 = "input" and step.withoutContent(anyPromiseContent()) and node2 = "raw-value"
    or
    node1 = "raw-value" and step.store(promiseValue()) and node2 = "promise-value"
    or
    node1 = "input" and step.withContent(promiseValue()) and node2 = "promise-value"
    or
    node1 = "promise-value" and step.store(iteratorElement()) and node2 = "output"
    or
    node1 = "input" and step.read(promiseError()) and node2 = "promise-error"
    or
    node1 = "promise-error" and step.store(iteratorError()) and node2 = "output"
  }
}

private class ShiftArrayElements extends Transform, Raw::ShiftArrayElements {
  private int amount;

  ShiftArrayElements() { this = Raw::ShiftArrayElements(amount) }

  override string toString() { result = "ShiftArrayElements(" + amount + ")" }

  override predicate step(string node1, Step step, string node2) {
    StandardTransforms::ShiftArrayContent<ArrayContent::Kind>::step(amount, node1, step, node2)
  }
}

private class ToArray extends Transform, Raw::ToArray {
  override string toString() { result = "ToArray" }

  override predicate step(string node1, Step step, string node2) {
    node1 = "input" and step.withContent(ArrayContent::anyElement()) and node2 = "output"
    or
    node1 = "input" and step.taint() and node2 = "tainted"
    or
    node1 = "tainted" and step.store(ArrayContent::anyElement()) and node2 = "output"
  }
}

module Transforms {
  /** Wraps a non-promise value in a succesful promise, and preserves existing promises as they are (including failed promises). */
  Transform toPromise() { result instanceof ToPromise }

  /** Maps a resolved promise to its value, non-promise values are preserved, and failed promises are blocked. */
  Transform awaitValue() { result instanceof AwaitValue }

  /** Maps an iterable value to its contents. */
  Transform readIterableContents() { result instanceof ReadIterableContents }

  /** Maps an async iterable value to its contents. */
  Transform readAsyncIterableContents() { result instanceof ReadAsyncIterableContents }

  /**
   * Coerces the incoming value to a promise and then wraps it in an iterator element.
   *
   * A failed promise is converted to a failed iterator.
   */
  Transform toAsyncIteratorElement() { result instanceof ToAsyncIteratorElement }

  /** Shifts array elements up by the given amount, or down if `amount` is negative. */
  Transform shiftArrayElements(int amount) { result = Raw::ShiftArrayElements(amount) }

  /** Preserves array contents, and boxes taint in an unknown array element. */
  Transform toArray() { result instanceof ToArray }
}
