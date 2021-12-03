class CheckOdd {
    private static boolean isOdd(int x) {
        return x % 2 == 1;
    }
    
    public static void main(String[] args) {
        System.out.println(isOdd(-9)); // prints false
    }
}