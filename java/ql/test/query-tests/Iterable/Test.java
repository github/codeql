import java.util.*;

class Test {
  void useIterable(Iterable<String> i) {
    for (String s : i) { }
    for (String s : i) { }
  }

  List<String> someStrings;

  void m() {
    useIterable(new Iterable<String>() {
      final Iterator<String> i = someStrings.iterator(); // bad
      
      @Override
      public Iterator<String> iterator() {
        return new Iterator<String>() {
          @Override
          public boolean hasNext() {
            return i.hasNext();
          }

          @Override
          public String next() {
            return "foo " + i.next();
          }

          @Override
          public void remove() {
            throw new UnsupportedOperationException();
          }
        };
      }
    });
    useIterable(new Iterable<String>() {
      @Override
      public Iterator<String> iterator() {
        return new Iterator<String>() {
          final Iterator<String> i = someStrings.iterator(); // ok
      
          @Override
          public boolean hasNext() {
            return i.hasNext();
          }

          @Override
          public String next() {
            return "foo " + i.next();
          }

          @Override
          public void remove() {
            throw new UnsupportedOperationException();
          }
        };
      }
    });
  }

  class Value { }
  class ValueIterator implements Iterator<Value> {
    private Value val = new Value();
    @Override
    public boolean hasNext() { return val != null; }
    @Override
    public Value next() {
      Value v = val;
      val = null;
      return v;
    }
    @Override
    public void remove() { }
  }

  protected class ValueIterableBad implements Iterable<Value> {
    private ValueIterator iterator = new ValueIterator(); // bad
    @Override
    public Iterator<Value> iterator() {
      return iterator;
    } 
  }

  protected class ValueIterableOk implements Iterable<Value> {
    @Override
    public Iterator<Value> iterator() {
      ValueIterator iterator = new ValueIterator(); // ok
      return iterator;
    } 
  }

  class MyCollectionOk implements Iterable<Integer> {
    final Iterator<Integer> emptyIter = new Iterator<Integer>() { // ok
          @Override
          public boolean hasNext() { return false; }
          @Override
          public Integer next() { throw new UnsupportedOperationException(); }
          @Override
          public void remove() { throw new UnsupportedOperationException(); }
        };
    private List<Integer> ints;
    MyCollectionOk(List<Integer> ints) { this.ints = ints; }
    public Iterator<Integer> iterator() {
      if (ints.size() == 0) return emptyIter;
      return ints.iterator();
    }
  }

  class IntIteratorBad implements Iterable<Integer>, Iterator<Integer> {
    private int[] ints;
    private int idx = 0;
    IntIteratorBad(int[] ints) {
      this.ints = ints;
    }
    @Override
    public boolean hasNext() {
      return idx < ints.length;
    }

    @Override
    public Integer next() {
      return ints[idx++];
    }

    @Override
    public void remove() {
      throw new UnsupportedOperationException();
    }

    public Iterator<Integer> iterator() {
      return this; // bad
    }
  }

  class IntIteratorOk implements Iterable<Integer>, Iterator<Integer> {
    private int[] ints;
    private int idx = 0;
    private boolean returnedIterator = false;
    IntIteratorOk(int[] ints) {
      this.ints = ints;
    }
    @Override
    public boolean hasNext() {
      return idx < ints.length;
    }

    @Override
    public Integer next() {
      return ints[idx++];
    }

    @Override
    public void remove() {
      throw new UnsupportedOperationException();
    }

    public Iterator<Integer> iterator() { // ok
      if (returnedIterator || idx > 0)
        throw new IllegalStateException();
      returnedIterator = true;
      return this;
    }
  }

  class EmptyIntIterator implements Iterable<Integer>, Iterator<Integer> {
    @Override
    public boolean hasNext() {
      return false;
    }
    @Override
    public Integer next() {
      throw new UnsupportedOperationException();
    }
    @Override
    public void remove() {
      throw new UnsupportedOperationException();
    }
    public Iterator<Integer> iterator() { // ok
      return this;
    }
  }

}
