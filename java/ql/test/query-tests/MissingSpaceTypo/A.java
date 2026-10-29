public class A {
  public void missing() {
    String s;
    s = "this text" +
      "is missing a space"; // $ Alert
    s = "the class java.util.ArrayList" +
      "without a space"; // $ Alert
    s = "This isn't" +
      "right."; // $ Alert
    s = "There's 1" +
      "thing wrong"; // $ Alert
    s = "There's A/B" +
      "and no space"; // $ Alert
    s = "Wait for it...." +
      "No space!"; // $ Alert
    s = "Is there a space?" +
      "No!"; // $ Alert
  }

  public void ok() {
    String s;
    s = "some words%n" +
      "and more";
    s = "some words\n" +
      "and more";
    s = "the class java.util." +
      "ArrayList";
    s = "some data: a,b,c," +
      "d,e,f";
  }
}
