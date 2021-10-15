public static void printCharacterCodes_Bad(String[] strings) {
    if (strings != null) {
        for (String s : strings) {
            if (s != null) {
                for (int i = 0; i < s.length(); i++) {
                    System.out.println(s.charAt(i) + "=" + (int) s.charAt(i));
                }
            }
        }
    }
}