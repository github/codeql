public class A {
  public void missing() {
    String s;
    s = "this text" + // $ Alert
      "is missing a space";
    s = "the class java.util.ArrayList" + // $ Alert
      "without a space";
    s = "This isn't" + // $ Alert
      "right.";
    s = "There's 1" + // $ Alert
      "thing wrong";
    s = "There's A/B" + // $ Alert
      "and no space";
    s = "Wait for it...." + // $ Alert
      "No space!";
    s = "Is there a space?" + // $ Alert
      "No!";
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
