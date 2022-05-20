package test;

public class UnreadLocals
{
  public static class Something
  {
    int x;
  }
  
  public Something something;
  public int       alpha;
  int              beta;
  private int      gamma;

  public UnreadLocals ()
  {
    int alpha = 2;
    int _beta = 4;
    this.alpha = 3;
    beta = _beta;

    Something something1 = new Something();
    Something something2 = new Something();
    
    something = something1;
    
    gamma = -1;
    
    something = makeSomething();
    
    makeSomething();
  }
  
  private static Something makeSomething ()
  {
    return new Something();
  }
}
