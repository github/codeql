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
               switch (thing) {
                   case String s -> System.out.println(s);
                   case Integer i -> System.out.println("An integer: " + i);
                   default -> { }
               }
               switch (thing) {
                   case String s:
                       System.out.println(s);
                       break;
                   case Integer i:
                       System.out.println("An integer:" + i);
                       break;
                   default:
                       break;
               }
               var thingAsString = switch(thing) {
                   case String s -> s;
                   case Integer i -> "An integer: " + i;
                   default -> "Something else";
               };
               var thingAsString2 = switch(thing) {
                   case String s:
                       yield s;
                   case Integer i:
                       yield "An integer: " + i;
                   default:
                       yield "Something else";
               };
               var nullTest = switch(thing) {
                   case null -> "Null";
                   default -> "Not null";
               };
           }
       }
       catch (RuntimeException rte) {
           return;
       }
   }

   enum E {
    /**
     * Javadoc for enum constant
     */
    A,
    B,
    C;
   }

   /**
    * Javadoc for fields
    */
    int i, j, k;
}
