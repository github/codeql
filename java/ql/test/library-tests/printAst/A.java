/** Another javadoc */

/** 
 * A class
 * 
 * @author someone
 */
class A {
  public @interface Ann1 { 
      String value() default "b";
      Ann2[] nest() default {};
   }

   public @interface Ann2 {
       int value() default 3;
   }

   /** Does something */
   @Deprecated
   static int doSomething(@SuppressWarnings("all") String text) {
       int i=0, j=1;

       for(i=0, j=1; i<3; i++) {}

       for(int m=0, n=1; m<3; m++) {}

       return 0;
   }

   int counter = 1;

   {
       counter = doSomething("hi");
   }

   @Ann1(
       value="a", 
       nest={
         @Ann2,
         @Ann2(7)
       })
   String doSomethingElse() { return "c"; }

   void varDecls(Object[] things) {
       try {
           for(Object thing : things) {
               if (thing instanceof Integer) {
                   return;
               }
               if (thing instanceof String s) {
                   throw new RuntimeException(s);
               }
           }
       }
       catch (RuntimeException rte) {
           return;
       }
   }
}