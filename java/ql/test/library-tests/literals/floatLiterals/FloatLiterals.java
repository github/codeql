package floatLiterals;

public class FloatLiterals {
	float[] floats = {
		0.0f,
		0f,
		.0f,
		0.f,
		1_0_0.0f,
		1.234567890123456789f,
		1.55555555555555555555f,
		// From the JLS
		1e1f,
		3.4028235e38f,
		0x1.fffffeP+127f,
		1.4e-45f,
		0x0.000002P-126f,
		0x1.0P-149f,
		// Using Unicode escapes (which are handled during pre-processing)
		\u0030\u002E\u0030\u0066, // 0.0f
	};

	// + and - are not part of the literal
	float[] floatsWithSign = {
		+0.f,
		-0.f,
		+1.0f,
		-1.0f,
		+3.4028235e38f,
		-3.4028235e38f,
	};

	// The operation expression (e.g. `+`) is not a literal
	float[] numericOperations = {
		0.0f + 0.0f,
		0.0f / 0.0f,
	};

	Object[] nonFloatLiterals = {
		"0f",
		'0',
		0,
		0.0,
		(float) 0.0,
		Float.MIN_VALUE,
	};

	float nonLiteral;
}
