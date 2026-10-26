import java.util.List;

public class Lib<T> {

  public void takesVar(T t) { }
  public void takesInvar(List<T> lt) { }
  public void takesUnbound(List<?> lt) { }
  public void takesExtends(List<? extends T> lt) { }
  public void takesSuper(List<? super T> lt) { }

  public T returnsVar() { return null; } 
  public List<T> returnsInvar() { return null; } 
  public List<?> returnsUnbound() { return null; } 
  public List<? extends T> returnsExtends() { return null; } 
  public List<? super T> returnsSuper() { return null; }

  public void takesArray(T[] ts) { }
  public T[] returnsArray() { return null; }

}
