//Test of ConstantExpAppearsNonConstant.ql

import java.util.*;

class Test{
	public void tester(){
	Random rnd = new Random();

	int lit = 42; //OK
	int paren = (9); //OK 
	int plusone = +1; //OK

	//Multiplication by 0
	int mul_not_constant = 42 * 6; //OK
	int mul_constant_left = 0 * 60 * 60 * 24; //OK
	int mul_constant_right = 60 * 60 * 24 * 0; //OK
	int mul_is_not_constant = rnd.nextInt() * 1; //OK
	int mul_is_constant_int_left = (0+0) * rnd.nextInt(); //NOT OK
	int mul_is_constant_int_right = rnd.nextInt() * (1-1); //NOT OK
	long mul_is_constant_hex = rnd.nextLong() * (0x0F & 0xF0); //NOT OK
	long mul_is_constant_binary = rnd.nextLong() * (0b010101 & 0b101010); //NOT OK
	int mul_explicit_zero = rnd.nextInt() * 0; //OK (deliberate zero multiplication)
	//Remainder by 1
	int rem_not_constant = 42 % 6; //OK
	int rem_constant = 60 % 1; //OK
	int rem_is_not_constant = rnd.nextInt() % 2; //OK
	int rem_is_constant_int = rnd.nextInt() % 1; //NOT OK
	double rem_is_constant_float = rnd.nextDouble() % 1; //OK (remainder by 1 on floats is not constant)
	long rem_is_constant_hex = rnd.nextLong() % 0x1; //NOT OK
	long rem_is_constant_binary = rnd.nextLong() % 01; //NOT OK

	//Bitwise 'and' by 0
	int band_not_constant = 42 & 6; //OK
	int band_appears_constant_left = 0 & 60; //OK
	int band_appears_constant_right = 24 & 0; //OK
	int band_is_not_constant = rnd.nextInt() & 5; //OK
	int band_is_constant_left = 0 & rnd.nextInt(); //NOT OK
	int band_is_constant_right = rnd.nextInt() & 0; //NOT OK

	//Logical 'and' by false
	boolean and_not_constant = true && true; //OK
	boolean and_appears_constant_left = false && true; //OK
	boolean and_appears_constant_right = true && false; //OK
	boolean and_is_not_constant = (rnd.nextInt() > 0) && true; //OK
	boolean and_is_constant_left = false && (rnd.nextInt() > 0); // don't flag (deliberately disabled)
	boolean and_is_constant_right = (rnd.nextInt() > 0) && false; // don't flag (deliberately disabled)

	//Logical 'or' by true
	boolean or_not_constant = false || false; //OK
	boolean or_appears_constant_left = true || false; //OK
	boolean or_appears_constant_right = false || true; //OK
	boolean or_is_not_constant = (rnd.nextInt() > 0) || false; //OK
	boolean or_is_constant_left = true || (rnd.nextInt() > 0); //NOT OK
	boolean or_is_constant_right = (rnd.nextInt() > 0) || true; //NOT OK
	}
}
