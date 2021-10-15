public void arrayExample(){
    String[] array1 = new String[]{"a", "b", "c"};
    String[] array2 = new String[]{"a", "b", "c"};

    // Reference equality tested: prints 'false'
    System.out.println(array1.equals(array2));
    
    // Equality of array elements tested: prints 'true'
    System.out.println(Arrays.equals(array1, array2));
}