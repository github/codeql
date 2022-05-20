package test;

public class ImplicitReads
{
  private static class B implements AutoCloseable
  {
    long time = 123;
    
    @Override
    public void close ()
    {
      System.out.println("Closing at time " + time);
    }
  }

  public void test()
  {
    // Not flagged due to implicit read in finally block
    try (B b = new B()) {
      System.out.println("test");
    }


    // Not flagged due to implicit read in finally block
    try (B b = null) {}
  }
  
  public void test2(B b)
  {
    if (b.time > 3) {
      System.out.println("test");
    }
    B c = null;
    if (c == null) {
      System.out.println("test");
    }
    // Assignment is useless
    c = b;
    // Not flagged due to implicit read in implicit finally block
    try(B d = b) {}
  }
}
