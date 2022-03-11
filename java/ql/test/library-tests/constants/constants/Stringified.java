package constants;

public class Stringified {
    void stringified(final String notConstant) {
        String withNotConstant = "a" + notConstant;
        String string = "a" + "b"; //ab
        String stringWithChar = "ab" + 'c'; //abc
        String stringWithBool = "ab" + true; //abtrue
        String stringWithInt = "ab" + 42; //ab42
        String stringWithDouble = "ab" + 43.0; //ab43.0
        String stringWithFloat = "ab" + 44.0f; //ab44.0
        String stringWithLong = "ab" + 45L; //ab45
        String stringWithShort = "ab" + (short) 46; //ab46
        String stringWithByte = "ab" + (byte) 47; //ab47
        String charWithString = 'a' + "bc"; //abc
        String boolWithString = true + "bc"; //truebc
        String intWithString = 42 + "bc"; //42bc
        String doubleWithString = 43.0 + "bc"; //43.0bc
        String floatWithString = 44.0f + "bc"; //44.0bc
        String longWithString = 45L + "bc"; //45bc
        String shortWithString = (short) 46 + "bc"; //46bc
        String byteWithString = (byte) 47 + "bc"; //47bc

        String stringWithExponent = "a" + 10e1; //a100
        String stringWithBooleanOr = "a" + (true || false); //atrue
        String stringWithIntDivide = "a" + (168 / 4); //a42
    }
}
