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
       return 0;
   }

   int counter = 1;

   {
       counter = doSomething("hi");
   }

   @Ann1(
       value="a", 
       nest={
         @Ann2(2),
         @Ann2(7)
       })
   String doSomethingElse() { return "c"; }
}