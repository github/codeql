public final class C1 {
   public final String taint(String t) {
      return t;
   }

   public final void sink(Object a) {
   }

   public final void test() {
      String[] l = new String[]{this.taint("a"), ""};
      this.sink(l);
      this.sink(l[0]);

      for(int i = 0; i < l.length; i++) {
         this.sink(l[i]);
      }

      for (String s : l) {
         this.sink(s);
      }
   }
}
