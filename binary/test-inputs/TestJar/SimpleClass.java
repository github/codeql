package testpackage;

public class SimpleClass {
    
    // Instance and static fields
    private int instanceField = 0;
    private static int staticField = 0;
    
    public void simpleMethod() {
        int x = 5;
        if (x > 0) {
            System.out.println("positive");
        } else {
            System.out.println("negative");
        }
    }
    
    public void callsOtherMethod() {
        simpleMethod();
    }
    
    public int add(int a, int b) {
        return a + b;
    }
    
    public void loopExample() {
        for (int i = 0; i < 10; i++) {
            System.out.println(i);
        }
    }
    
    // Test float and double constants
    public float getPi() {
        return 3.14159f;
    }
    
    public double getE() {
        return 2.71828;
    }
    
    public double floatArithmetic(float a, double b) {
        float localFloat = 1.5f;
        double localDouble = 2.5;
        return (a + localFloat) * (b + localDouble);
    }
    
    // Test more local variable operations
    public int localVariableTest() {
        int a = 1;
        int b = 2;
        int c = 3;
        int d = 4;
        int e = 5;  // Forces use of iload/istore with index operand
        return a + b + c + d + e;
    }
    
    // Test array operations
    public int arrayTest() {
        int[] arr = new int[5];
        arr[0] = 10;
        arr[1] = 20;
        arr[2] = 30;
        return arr[0] + arr[1] + arr[2];
    }
    
    public float[] floatArrayTest() {
        float[] arr = new float[3];
        arr[0] = 1.1f;
        arr[1] = 2.2f;
        arr[2] = 3.3f;
        return arr;
    }
    
    // Test field operations
    public void fieldTest() {
        instanceField = 10;
        int x = instanceField;
        staticField = 20;
        int y = staticField;
    }
    
    // Test type conversions
    public void conversionTest() {
        int i = 42;
        long l = (long)i;       // i2l
        float f = (float)i;     // i2f
        double d = (double)i;   // i2d
        byte b = (byte)i;       // i2b
        short s = (short)i;     // i2s
        char c = (char)i;       // i2c
    }
    
    // Test exception handling
    public void exceptionTest() {
        try {
            throw new IllegalStateException("test");
        } catch (IllegalStateException ex) {
            System.out.println(ex.getMessage());
        } finally {
            System.out.println("finally");
        }
    }
    
    // Test type checking
    public void typeCheckTest(Object obj) {
        if (obj instanceof String) {
            String str = (String)obj;
            System.out.println(str);
        }
        
        SimpleClass cast = (SimpleClass)obj;
    }
    
    // Test bitwise operations
    public int bitwiseTest(int a, int b) {
        int andResult = a & b;
        int orResult = a | b;
        int xorResult = a ^ b;
        int shlResult = a << 2;
        int shrResult = a >> 2;
        int ushrResult = a >>> 2;
        return andResult + orResult + xorResult + shlResult + shrResult + ushrResult;
    }
    
    // Test comparison operations
    public boolean comparisonTest(int a, int b) {
        boolean eq = a == b;
        boolean lt = a < b;
        boolean gt = a > b;
        return eq || lt || gt;
    }
    
    // Test switch statement (tableswitch)
    public String switchTest(int value) {
        switch (value) {
            case 0: return "zero";
            case 1: return "one";
            case 2: return "two";
            default: return "other";
        }
    }
    
    // Test switch with sparse values (lookupswitch)
    public String sparseSwitchTest(int value) {
        switch (value) {
            case 1: return "one";
            case 100: return "hundred";
            case 1000: return "thousand";
            default: return "other";
        }
    }
    
    // Test long comparisons
    public int longCompareTest(long a, long b) {
        if (a < b) return -1;
        if (a > b) return 1;
        return 0;
    }
    
    // Test double comparisons
    public int doubleCompareTest(double a, double b) {
        if (a < b) return -1;
        if (a > b) return 1;
        return 0;
    }
    
    // Test object creation
    public WriteToField createObject() {
        return new WriteToField(42);
    }
    
    // Test interface call
    public int interfaceCall(java.util.List<String> list) {
        return list.size();
    }
    
    // Test static method call
    public static int staticMethod(int x) {
        return x * 2;
    }
    
    // Test monitor (synchronized)
    public synchronized void synchronizedMethod() {
        System.out.println("synchronized");
    }
    
    // Test multidimensional array
    public int[][] multiArrayTest() {
        int[][] arr = new int[3][4];
        arr[0][0] = 1;
        return arr;
    }
}

class WriteToField {
    public int value;
    
    public WriteToField(int x) {
        value = x;
    }
}

class LoadFromFieldClass {
    public static int loadFromField() {
        WriteToField a = new WriteToField(5);
        return a.value;
    }
}
