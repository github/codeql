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

     switch(thing) {
       case String s when s.length() == 3:
         System.out.println("Length 3");
         break;
       case String s when s.length() == 5:
         System.out.println("Length 5");
         break;
       default:
         System.out.println("Anything else");
         break;
     }

     switch(thing) {
       case String s when s.length() == 3 -> System.out.println("Length 3");
       case String s when s.length() == 5 -> System.out.println("Length 5");
       default -> { }
     }

     switch((String)thing) {
       case "Const1":
         System.out.println("It's Const1!");
       case "Const2":
         System.out.println("It's Const1 or Const2!");
         break;
       case String s when s.length() <= 6:
         System.out.println("It's <= 6 chars long, and neither Const1 nor Const2");
       case "Const3":
         System.out.println("It's (<= 6 chars long, and neither Const1 nor Const2), or Const3");
         break;
       case "Const30":
         System.out.println("It's Const30");
         break;
       case null, default:
         System.out.println("It's null, or something else");
     }

     switch(thing) {
       case String s:
         System.out.println(s);
         break;
       case null:
         System.out.println("It's null");
         break;
       case Integer i:
         System.out.println("An integer:" + i);
         break;
       default:
         break;
     }

     switch(thing) {
       case A(B(int x, String y), float z):
         break;
       default:
         break;
     }

     switch(thing) {
       case A(B(var x, var y), var z):
         break;
       default:
         break;
     }

     switch(thing) {
       case B(_, _):
       case Integer _, String _, A(_, _) when thing.toString().equals("abc"):
       case Float _:
         break;
       default:
         break;
     }

     var result = switch(thing) {
       case B(_, _):
       case Integer _, String _, A(_, _) when thing.toString().equals("abc"):
       case Float _:
         yield 1;
       default:
         yield 2;
     };

     switch ((String)thing) {
       case "a":
       case String _ when ((String)thing).length() == 5:
       case "b":
         break;
       default:
         break;
     }

     // Test the case where a case falls out of a switch block without a break:
     switch(thing) {
       case String _:
       default:
     }

  }

}

record A(B b, float field3) { }
record B(int field1, String field2) { }
