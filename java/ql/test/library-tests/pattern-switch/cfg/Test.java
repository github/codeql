public class Test {

  public static void test(Object thing) {

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

  }

}
