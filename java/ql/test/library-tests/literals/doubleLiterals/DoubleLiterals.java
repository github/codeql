package doubleLiterals;

public class DoubleLiterals {
	double[] doubles = {
		0.0,
		0d,
		0D,
		.0d,
		.0,
		0.,
		1.234567890123456789,
		1.55555555555555555555,
		// From the JLS
		1e1,
		1.7976931348623157E308,
		0x1.f_ffff_ffff_ffffP+1023,
		4.9e-324,
		0x0.0_0000_0000_0001P-1022,
		0x1.0P-1074,
		// Using Unicode escapes (which are handled during pre-processing)
		\u0030\u002E\u0030, // 0.0
	};

	// + and - are not part of the literal
	double[] doublesWithSign = {
		+0.0,
		-0.0,
		+1.0,
		-1.0,
		+1.7976931348623157E308,
		-1.7976931348623157E308,
	};

	// The operation expression (e.g. `+`) is not a literal
	double[] numericOperations = {
		0.0 + 0.0,
		0.0 / 0.0,
	};

	Object[] nonDoubleLiterals = {
		"0",
		'0',
		0,
		0.0f,
		(double) 0.0f,
		Double.MIN_VALUE,
	};

	double nonLiteral;
}
