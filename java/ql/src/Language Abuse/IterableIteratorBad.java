class ElemIterator implements Iterator<MyElem>, Iterable<MyElem> {
  private MyElem[] data;
  private idx = 0;

  public boolean hasNext() {
    return idx < data.length;
  }
  public MyElem next() {
    return data[idx++];
  }
  public Iterator<MyElem> iterator() {
    return this;
  }
  // ...
}

void useMySequence(Iterable<MyElem> s) {
  // do some work by traversing the sequence
  for (MyElem e : s) {
    // ...
  }
  // do some more work by traversing it again
  for (MyElem e : s) {
    // ...
  }
}
