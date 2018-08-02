enum color {red, green, blue, cyan, magenta, yellow};

void f(enum color c);
void g(enum color c);

void m(enum color value) {
	switch(value) {
	case red:						// compliant
	case green:						// compliant
	case blue:						// non-compliant
		f(value);
	case cyan:						// compliant
	case magenta:					// compliant
	case yellow:					// compliant
		g(value);
		break;
	}

	switch(value) {
	case red:				// COMPLIANT
	case green:				// COMPLIANT
		f(value);
		break;
	case cyan:				// COMPLIANT
		g(value);
		break;
	default:				// COMPLIANT
		g(value);
	}

	switch(value) {
	case red:				// COMPLIANT
	case green:				// COMPLIANT
		f(value);
		break;
	default:				// NON-COMPLIANT
		g(value);
	case cyan:				// COMPLIANT
		g(value);
		break;
	}

	switch(value) {
	case red:				// COMPLIANT
	case green:				// COMPLIANT
		f(value);
		return;
	case cyan:				// COMPLIANT
		g(value);
		return;
	}

	switch(value) {
	case red:				// COMPLIANT
	case green:				// COMPLIANT
		{
			f(value);
			return;
		}
	case cyan:				// COMPLIANT
		{
			g(value);
			return;
		}
	}

	switch(value) {
	case red:				// COMPLIANT
	case green:				// COMPLIANT
		{
			f(value);
			break;
		}
	case cyan:				// COMPLIANT
		{
			g(value);
			break;
		}
	}
}
