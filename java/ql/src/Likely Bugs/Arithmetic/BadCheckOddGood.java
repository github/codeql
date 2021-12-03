class CheckOdd {
    private static boolean isOdd(int x) {
        return x % 2 != 0;
    }
    
    public static void main(String[] args) {
        System.out.println(isOdd(-9)); // prints true
    }
}