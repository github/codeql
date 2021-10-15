class MySequence implements Iterable<MyElem> {
  // ... some reference to data
  public Iterator<MyElem> iterator() {
    return new Iterator<MyElem>() {
      // Correct: iteration state inside returned iterator
      final Iterator<MyElem> it = data.iterator();
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
