
typedef unsigned long long uint64_t;
#define PRIu64 "llu"
#define PRIx64 "llx"
#define PRIi64 "lli"
#define PRIu32 "u"
#define UINT64_MAX 0xFFFFFFFFFFFFFFFF

void test_PRI_macros() {
	uint64_t my_u64 = UINT64_MAX;

	printf("my_u64 = %" PRIu64 "\n", my_u64); // GOOD
	printf("my_u64 = %" PRIx64 "\n", my_u64); // GOOD
	printf("my_u64 = %" PRIi64 "\n", my_u64); // BAD: uint64_t read as int64_t [NOT DETECTED]
	printf("my_u64 = %" PRIu32 "\n", my_u64); // BAD: uint64_t read as uint32_t
}
