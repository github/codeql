package constants;

/** Tests of the getIntValue() predicate */
class Values {

    final int final_field = 42; //42

    void values(final int notConstant) {
        int int_literal = 42; //42
        int negative_int_literal = -2147483648; //-2147483648
        int octal_literal = 052; //42
        int negative_octal_literal = -052; //-42
        int hex_literal = 0x2A; //42
        int negative_hex_literal = -0x2A; //-42
        int hex_literal_underscores = 0x2_A; //42
        int binary_literal = 0b101010; //42
        int negative_binary_literal = -0b101010; //-42
        int binary_literal_underscores = 0b1_0101_0; //42
        char char_literal = '*'; //42
        long long_literal = 42L; //Not handled
        boolean boolean_literal = true; //true
        Integer boxed_int = new Integer(42); //Not handled
        int parameter = notConstant; //Not constant

        int cast = (int) 42; //42
        char downcast = (char) 42; //42
        byte downcast_byte_1 = (byte) (-42); // -42
        byte downcast_byte_2 = (byte) 42; // 42
        byte downcast_byte_3 = (byte) 298; // 42
        byte downcast_byte_4 = (byte) 214; // -42
        byte downcast_byte_5 = (byte) (-214); // 42
        short downcast_short = (short) 32768; // -32768
        int cast_of_non_constant = (int) '*'; //42
        long cast_to_long = (long) 42; //Not handled

        int unary_plus = +42; //42
        int parameter_plus = +notConstant; //Not constant

        int unary_minus = -42; //-42
        int parameter_minus = -notConstant; //Not constant

        boolean not = !true; //false
        int bitwise_not = ~0; //-1

        int mul = 7 * 9; //42 (well, in base 13, anyway - in base 10 it is 63)
        int mul_parameter = notConstant * notConstant; //Not constant

        int div = 168 / 4; //42
        int div_by_zero = 42 / 0; //Not constant
        int div_parameter = notConstant / notConstant; //Not constant

        int rem = 168 % 63 ; //42
        int rem_by_zero = 42 % 0 ; //Not constant
        int rem_parameter = notConstant % notConstant; //Not constant

        int plus = 10 + 32 ; //42
        int plus_parameter = notConstant + notConstant; //Not constant

        int minus = 168 - 126 ; //42
        int minus_parameter = notConstant - notConstant; //Not constant

        int lshift = 21 << 2; //84
        int lshift_parameter = notConstant << notConstant; //Not constant

        int rshift = -1 >> 2; //-1
        int urshift = -1 >>> 1; //2147483647
        int bitwise_and = 63 & 42; //42
        int bitwise_or = 32 | 42; //42
        int bitwise_xor = 48 ^ 26; //42
        boolean and = true && false; //false
        boolean or = true || false; //true
        boolean lt = 42 < 42; //false
        boolean le = 42 <= 42; //true
        boolean gt = 42 > 42; //false
        boolean gle = 42 >= 42; //true
        boolean eq = 42 == 42; //true
        boolean ne = 42 != 42; //false
        boolean ter = true ? false : true; // false

        boolean seq = "foo" == "foo"; //true
        boolean sneq = "foo" != "foo"; //false

        int par = (42); //42
        int par_not_constant = (notConstant); //Not constant

        int var_field = final_field; //42
        final int final_local = 42; //42
        int var_local = final_local; //42
        int var_param = notConstant; //Not constant
        int var_nonfinald_local = var_field; //Not constant
    }
}
