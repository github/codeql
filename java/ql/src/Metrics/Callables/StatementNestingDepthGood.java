public static void printAllCharInts(String s) {
    if (s != null) {
        for (int i = 0; i < s.length(); i++) {
            System.out.println(s.charAt(i) + "=" + (int) s.charAt(i));
        }
    }
}
public static void printCharacterCodes_Good(String[] strings) {
    if (strings != null) {
        for(String s : strings){
            printAllCharInts(s);
        }
    }
}