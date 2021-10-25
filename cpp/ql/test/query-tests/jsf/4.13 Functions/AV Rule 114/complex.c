
_Complex double complexTest1(float a, float b) {
	_Complex double x = __builtin_complex(a, b); // BAD
}

_Complex double complexTest2(float a, float b) {
	auto x = __builtin_complex(a, b) * 2.0f; // BAD
}

_Complex double complexTest3(float a, float b) {
	return __builtin_complex(a, b); // GOOD
}

auto complexTest4(float a, float b) {
	return __builtin_complex(a, b) * 2.0f; // GOOD
}
