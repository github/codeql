class ElemIterator implements Iterator<MyElem>, Iterable<MyElem> {
  private MyElem[] data;
  private idx = 0;
  private boolean usedAsIterable = false;

  public boolean hasNext() {
    return idx < data.length;
  }
  public MyElem next() {
    return data[idx++];
  }
  public Iterator<MyElem> iterator() {
    if (usedAsIterable || idx > 0)
      throw new IllegalStateException();
    usedAsIterable = true;
    return this;
  }
  // ...
}
