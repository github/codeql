public static void main(String args[]) {
    Random r = new Random();

    // BAD: 'mayBeNegativeInt' is negative if
    // 'nextInt()' returns 'Integer.MIN_VALUE'.
    int mayBeNegativeInt = Math.abs(r.nextInt());

    // GOOD: 'nonNegativeInt' is always a value between 0 (inclusive)
    // and Integer.MAX_VALUE (exclusive).
    int nonNegativeInt = r.nextInt(Integer.MAX_VALUE);

    // GOOD: When 'nextInt' returns a negative number increment the returned value.
    int nextInt = r.nextInt();
    if(nextInt < 0)
        nextInt++;
    int nonNegativeInt = Math.abs(nextInt);
}
