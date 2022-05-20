public static void main(String args[]) {
    String phrase = "I miss my home in Mississippi.";

    // AVOID: Calling 'toLowerCase()' or 'toUpperCase()'
    // produces different results depending on what the default locale is.
    System.out.println(phrase.toUpperCase());
    System.out.println(phrase.toLowerCase());

    // GOOD: Explicitly setting the locale when calling 'toLowerCase()' or
    // 'toUpperCase()' ensures that the resulting string is
    // English, regardless of the default locale.
    System.out.println(phrase.toLowerCase(Locale.ENGLISH));
    System.out.println(phrase.toUpperCase(Locale.ENGLISH));
}