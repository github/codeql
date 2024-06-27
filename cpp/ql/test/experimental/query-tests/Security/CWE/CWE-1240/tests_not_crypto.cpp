// Non-cryptography snippets.  Nothing in this file should be flagged by the query.

typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;

// a very cut down stub for `std::cout`
namespace std
{
	template<class charT> struct char_traits;

	template <class charT, class traits = char_traits<charT> >
	class basic_ostream {
	public:
		typedef charT char_type;
	};
	template<class charT, class traits> basic_ostream<charT,traits>& operator<<(basic_ostream<charT,traits>&, const charT*);

	typedef basic_ostream<char> ostream;

	extern ostream cout;
}

// this macro expands to some compute operations that look a bit like cryptography
#define COMPUTE(v) \
	v[0] ^= v[1] ^ v[2] ^ v[3] ^ v[4]; \
	v[1] ^= v[2] ^ v[3] ^ v[4] ^ v[5]; \
	v[2] ^= v[3] ^ v[4] ^ v[5] ^ v[6]; \
	v[3] ^= v[4] ^ v[5] ^ v[6] ^ v[7];

// ---

#include "library/tests_library.h"

bool isEnabledAes() {
	// This function has "Aes" in it's name, but does not contain enough compute to
	// be an encryption implementation.
	return false;
}

uint32_t lookup[256];

uint8_t computeCRC32(const uint8_t *data, size_t dataLen) {
	// This function has "RC3" in its name, but is not an implementation of the (broken) RC3 encryption algorithm.
	uint32_t result = 0xFFFFFFFF;

	for (size_t i = 0; i < dataLen; i++) {
		result = (result >> 8) + lookup[(result ^ data[i]) & 0xFF];
		result = (result >> 8) + lookup[(result ^ data[i]) & 0xFF]; // artificial extra compute
		result = (result >> 8) + lookup[(result ^ data[i]) & 0xFF]; // artificial extra compute
		result = (result >> 8) + lookup[(result ^ data[i]) & 0xFF]; // artificial extra compute
	}

	return result ^ 0xFFFFFFFF;
}

void convert_image_universal(uint32_t *img, int width, int height) {
	// This function has "rsa" in its name, but is nothing to do with the RSA encryption algorithm.
	uint32_t *pixel_ptr = img;
	uint32_t num_pixels = width * height;

	// convert pixels RGBA -> ARGB (with probably unhelpful loop unrolling)
	while (num_pixels >= 4) {
		pixel_ptr[0] = (pixel_ptr[0] >> 8) ^ (pixel_ptr[0] << 24);
		pixel_ptr[1] = (pixel_ptr[1] >> 8) ^ (pixel_ptr[1] << 24);
		pixel_ptr[2] = (pixel_ptr[2] >> 8) ^ (pixel_ptr[2] << 24);
		pixel_ptr[3] = (pixel_ptr[3] >> 8) ^ (pixel_ptr[3] << 24);
		num_pixels -= 4;
	}
	if (num_pixels >= 2) {
		pixel_ptr[0] = (pixel_ptr[0] >> 8) ^ (pixel_ptr[0] << 24);
		pixel_ptr[1] = (pixel_ptr[1] >> 8) ^ (pixel_ptr[1] << 24);
		num_pixels -= 2;
	}
	if (num_pixels >= 1) {
		pixel_ptr[2] = (pixel_ptr[2] >> 8) ^ (pixel_ptr[2] << 24);
	}
}

const char* yes_no_setting() { return "no"; }

void output_encrypt_decrypt_algorithms() {
	// This function has "encrypt" and "decrypt" in its name, but no encryption is done.
	// This function uses `<<` heavily, but not as an integer shift left.
	const char *indent = "  ";

	std::cout << "Supported algorithms:\n";
	std::cout << indent << "DES (" << yes_no_setting() << ")\n";
	std::cout << indent << "3DES (" << yes_no_setting() << ")\n";
	std::cout << indent << "AES (" << yes_no_setting() << ")\n";
	std::cout << indent << "RSA (" << yes_no_setting() << ")\n";
	std::cout << indent << "Blowfish (" << yes_no_setting() << ")\n";
	std::cout << indent << "Twofish (" << yes_no_setting() << ")\n";
	std::cout << indent << "Chacha (" << yes_no_setting() << ")\n";
}

void wideStringCharsAt(int *v) {
	// This function has "des" and "rsa" in the name.
	COMPUTE(v)
}

void bitcastVariable(int *v) {
	// This function has "aria" and "cast" in the name.
	COMPUTE(v)
}

void dividesVariance(int *v) {
	// This function has "des" and "aria" in the name.
	COMPUTE(v)
}

void broadcastNodes(int *v) {
	// This function has "cast" and "des" in the name.
	COMPUTE(v)
}

#define ROTATE(val, amount) ( (val << amount) | (val >> (32 - amount)) )

static inline void hashMix(const int *data, int &state) {
	// This function looks like part of a hashing function.  It's not necessarily intended to
	// be a cryptographic hash, so should not be flagged.
	state ^= data[0];
	ROTATE(state, 1);
	state ^= data[1];
	ROTATE(state, 7);
	state ^= data[2];
	ROTATE(state, 11);
	state ^= data[3];
	ROTATE(state, 3);
	state ^= data[4];
	ROTATE(state, 13);
	state ^= data[5];
	ROTATE(state, 5);
	state ^= data[6];
	ROTATE(state, 2);
	state ^= data[7];
	ROTATE(state, 17);
}
