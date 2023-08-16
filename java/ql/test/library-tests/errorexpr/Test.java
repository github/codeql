public class Test {

  public int yield(int x) { return x; }

  public void secondCall() { }

  public int yieldWrapper(int x) { 
    int ret = yield(x); 
    secondCall();
    return ret;
  }

}
