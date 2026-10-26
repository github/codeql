class MySequence implements Iterable<MyElem> {
  // ... some reference to data
  final Iterator<MyElem> it = data.iterator();
  // Wrong: reused iterator
  public Iterator<MyElem> iterator() {
    return it;
  }
}

void useMySequence(MySequence s) {
  // do some work by traversing the sequence
  for (MyElem e : s) {
    // ...
  }
  // do some more work by traversing it again
  for (MyElem e : s) {
    // ...
  }
}
