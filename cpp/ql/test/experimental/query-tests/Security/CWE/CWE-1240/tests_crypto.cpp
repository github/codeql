// Cryptography snippets.  All (non-stub) functions in this file should be flagged by the query.

typedef unsigned char uint8_t;

int strlen(const char *string);

// ---

// the following function is homebrew crypto written for this test.  This is a bad algorithm
// on multiple levels and should never be used in cryptography.
void encryptString(char *string, unsigned int key) {
	char *ptr = string;
	int len = strlen(string);

	while (len >= 4) {
		// encrypt block by XOR-ing with the key
		ptr[0] = ptr[0] ^ (key >> 0);
		ptr[1] = ptr[1] ^ (key >> 8);
		ptr[2] = ptr[2] ^ (key >> 16);
		ptr[3] = ptr[3] ^ (key >> 24);

		// move on
		ptr += 4;
		len -= 4;
	}
}

// the following function is homebrew crypto written for this test.  This is a bad algorithm
// on multiple levels and should never be used in cryptography.
void MyEncrypt(const unsigned int *dataIn, unsigned int *dataOut, unsigned int dataSize, unsigned int key[2]) {
	unsigned int state[2];
	unsigned int t;

	state[0] = key[0];
	state[1] = key[1];
	
	for (unsigned int i = 0; i < dataSize; i++) {
		// mix state
		t = state[0];
		state[0] = (state[0] << 1) | (state[1] >> 31);
		state[1] = (state[1] << 1) | (t >> 31);

		// encrypt data
		dataOut[i] = dataIn[i] ^ state[0];
	}
}

// the following function resembles an implementation of the AES "mix columns"
// step. It is not accurate, efficient or safe and should never be used in
// cryptography.
void mix_columns(const uint8_t inputs[4], uint8_t outputs[4]) {
	// The "mix columns" step takes four bytes as inputs. Each byte represents a
	// polynomial with 8 one-bit coefficients, e.g. input bits 00001101
	// represent the polynomial x^3 + x^2 + 1.  Arithmetic is reduced modulo
	// x^8 + x^4 + x^3 + x + 1 (= 0x11b).
	//
	// The "mix columns" step multiplies each input by 2 (in the field described
	// above) to produce four more values. The output is then four values
	// produced by XOR-ing specific combinations of five of these eight values.
	// The exact values selected here do not match the actual AES algorithm.
	//
	// We avoid control flow decisions that depend on the inputs.
	uint8_t vs[4];

	vs[0] = inputs[0] << 1; // multiply by two
	vs[0] ^= (inputs[0] >> 7) * 0x1b; // reduce modulo 0x11b; the top bit was removed in the shift.
	vs[1] = inputs[1] << 1;
	vs[1] ^= (inputs[1] >> 7) * 0x1b;
	vs[2] = inputs[2] << 1;
	vs[2] ^= (inputs[2] >> 7) * 0x1b;
	vs[3] = inputs[3] << 1;
	vs[3] ^= (inputs[3] >> 7) * 0x1b;

	outputs[0] = inputs[0] ^ inputs[1] ^ inputs[2] ^ vs[0] ^ vs[1];
	outputs[1] = inputs[1] ^ inputs[2] ^ inputs[3] ^ vs[1] ^ vs[2];
	outputs[2] = inputs[2] ^ inputs[3] ^ inputs[0] ^ vs[2] ^ vs[3];
	outputs[3] = inputs[3] ^ inputs[0] ^ inputs[1] ^ vs[3] ^ vs[0];
}

// the following function resembles initialization of an S-box as may be done
// in an implementation of DES, AES and other encryption algorithms. It is not
// accurate, efficient or safe and should never be used in cryptography.
void init_aes_sbox(unsigned char data[256]) {
	// initialize `data` in a loop using lots of ^, ^= and << operations and
	// a few fixed constants.
	unsigned int state = 0x12345678;

	for (int i = 0; i < 256; i++)
	{
		state ^= (i ^ 0x86) << 24;
		state ^= (i ^ 0xb9) << 16;
		state ^= (i ^ 0x11) << 8;
		state ^= (i ^ 0x23) << 0;
		state = (state << 1) ^ (state >> 31);
		data[i] = state & 0xff;
	}
}
