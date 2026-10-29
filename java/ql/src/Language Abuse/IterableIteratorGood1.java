class ElemSequence implements Iterable<MyElem> {
  private MyElem[] data;

  public Iterator<MyElem> iterator() {
    return new Iterator<MyElem>() {
      private idx = 0;
      public boolean hasNext() {
        return idx < data.length;
      }
      public MyElem next() {
        return data[idx++];
      }
    };
  }
  // ...
}
