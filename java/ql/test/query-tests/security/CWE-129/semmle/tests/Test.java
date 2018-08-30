// Test case for
// CWE-129: Improper Validation of Array Index
// http://cwe.mitre.org/data/definitions/129.html

package test.cwe129.cwe.examples;

import java.security.SecureRandom;

class Test {
  public static void basic() {

    int array[] = { 0, 1, 2, 3, 4 };
    String userProperty = System.getProperty("userProperty");
    try {
        int index = Integer.parseInt(userProperty.trim());

        // BAD Accessing array without conditional check
        System.out.println(array[index]);

        if (index >= 0 && index < array.length) {
          // GOOD Accessing array under conditions
          System.out.println(array[index]);
        }

        try {
          /*
           * GOOD Accessing array, but catch ArrayIndexOutOfBounds, so someone has at least
           * considered the consequences.
           */
          System.out.println(array[index]);
        } catch (ArrayIndexOutOfBoundsException ex) {
        }
    } catch(NumberFormatException exceptNumberFormat) {
    }
  }

  public static void random() {
    int array[] = { 0, 1, 2, 3, 4 };

    int index = (new SecureRandom()).nextInt(10);

    // BAD Accessing array without conditional check
    System.out.println(array[index]);

    if (index < array.length) {
      // GOOD Accessing array under conditions
      System.out.println(array[index]);
    }

    // GOOD, the array access is protected by short-circuiting
    if (index < array.length && array[index] > 0) {
    }
  }

  public static void construction() {

    String userProperty = System.getProperty("userProperty");
    try {
        int size = Integer.parseInt(userProperty.trim());

        int[] array = new int[size];

        // BAD The array was created without checking the size, so this access may be dubious
        System.out.println(array[0]);

        if (size >= 0) {
          int[] array2 = new int[size];

          // BAD The array was created without checking that the size is greater than zero
          System.out.println(array2[0]);
        }

        if (size > 0) {
            int[] array3 = new int[size];

            // GOOD We verified that this was greater than zero
            System.out.println(array3[0]);
          }

    } catch(NumberFormatException exceptNumberFormat) {
    }
  }

  public static void constructionBounded() {

    int size = 0;

    int[] array = new int[size];

    // BAD Array may be empty.
    System.out.println(array[0]);

    int index = 0;
    if (index < array.length) {
      // GOOD protected by length check
      System.out.println(array[index]);
    }

    size = 2;
    array = new int[2];
    // GOOD array size is guaranteed to be larger than zero
    System.out.println(array[0]);
  }
}