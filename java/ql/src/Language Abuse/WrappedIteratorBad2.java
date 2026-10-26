class MySequence implements Iterable<MyElem> {
  // ... some reference to data
  final Iterator<MyElem> it = data.iterator();
  // Wrong: iteration state outside returned iterator
  public Iterator<MyElem> iterator() {
    return new Iterator<MyElem>() {
      public boolean hasNext() {
        return it.hasNext();
      }
      public MyElem next() {
        return transformElem(it.next());
      }
      public void remove() {
        // ...
      }
    };
  }
}
