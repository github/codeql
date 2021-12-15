public class B {
   private final Object lock = new Object();
   private Object field;

   public void setField(Object o){
       synchronized (lock){      // GOOD: synchronize on a separate lock object
           field = o;
           // ... more code ...
       }
   }
}