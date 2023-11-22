public class B {
    public B() {
        ;
    }

   public void fn() { }
   public C<C<Integer>> fn(C<C<Integer>> i) { return i; }
   public int fn(int i) {
      int x = this.fn(1);
      Enu e = Enu.A;
      return B.x;
   }

   public static class C<T> {
      public void fn() {
         new C<C<Integer>>();
      }
   }

   public static enum Enu {
      A, B, C
   }

   public static final int x = 5;
}
