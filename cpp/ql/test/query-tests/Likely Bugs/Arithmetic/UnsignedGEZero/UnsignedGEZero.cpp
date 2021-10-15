
#include "assert.h"

#define NULL 0
#define ZERO 0
#define UI ui
#define GE >=
#define CHECK_RANGE(x, min, max) (((x) >= (min)) && ((x) <= (max)))

typedef signed short S16;
typedef unsigned short U16;

enum myEnum1 { // this enum might have a signed type
	RED = 0,
	GREEN,
	BLUE
};

enum myEnum2 { // this enum must have a signed type
	APPLE = -1,
	BANANA,
	PEAR
};

const int const_zero = 0;
int maybe_zero = 0;

void myFunction() {
	unsigned int ui, *ui_ptr;
	signed int si;
	unsigned char uc;
	signed char sc;
	U16 u16;
	S16 s16;
	unsigned long long ull;
	signed long long sll;
	myEnum1 e1;
	myEnum2 e2;

	if (ui >= 0) { // violation
	}
	if (ui >= 1) {
	}
	if (ui > 0) {
	}
	if (ui < 0) {
	}
	if (UI >= ZERO) { // violation
	}
	if (si >= 0) {
	}
	if (ui_ptr >= NULL) { // unsafe, but not a violation of UnsignedGEZero.ql
	}
	if (uc >= 0) { // violation
	}
	if (sc >= 0) {
	}
	if (u16 >= 0) { // violation
	}
	if (s16 >= 0) {
	}
	if (ull >= 0) { // violation
	}
	if (sll >= 0) {
	}
	if (e1 >= RED) {
	}
	if (e2 >= APPLE) {
	}
	if (e2 >= BANANA) {
	}
	if (e2 >= 0) {
	}

	if (ui >= const_zero) { // violation
	}
	if (ui >= maybe_zero) {
	}

	if ((unsigned int)si >= 0) { // violation
	}
	if ((signed int)ui >= 0) {
	}
	if ((unsigned char)ui >= 0) { // violation
	}
	if ((signed char)ui >= 0) {
	}
	if ((unsigned char)si >= 0) { // violation
	}
	if ((signed char)si >= 0) {
	}
	if ((signed int)uc >= 0) { // violation
	}
	if ((unsigned int)uc >= 0) { // violation
	}
	if ((signed int)sc >= 0) {
	}
	if ((unsigned int)sc >= 0) { // violation
	}

	assert(ui >= 0); // violation
	assert(si >= 0);

	CHECK_RANGE(ui, 0, 10); // reasonable use
	CHECK_RANGE(si, 0, 10);
	CHECK_RANGE(e1, RED, BLUE);
	CHECK_RANGE(e2, APPLE, PEAR);
	CHECK_RANGE(e2, BANANA, PEAR);
	CHECK_RANGE(e2, 0, PEAR);

	assert(ui >= 0 && ui <= 100); // violation
	assert(CHECK_RANGE(ui, 0, 10)); // reasonable use
	assert(UI >= ZERO); // violation (not detected)
	assert(ui GE 0); // violation

	if ((unsigned char)si >= 0) { // violation
	}
	if ((unsigned char)(signed int)si >= 0) { // violation
	}
	if ((signed int)(unsigned char)si >= 0) { // violation
	}
	if ((unsigned char)(signed char)si >= 0) { // violation
	}
	if ((signed char)(unsigned char)si >= 0) {
	}

	if ((signed int)(unsigned char)(signed int)si >= 0) { // violation
	}
	if ((signed char)(unsigned char)(signed int)si >= 0) {
	}
	if ((signed int)(unsigned char)(signed char)si >= 0) { // violation
	}

	if (ui <= 0) {
	}
	if (0 <= ui) { // violation
	}
	if (0 < ui) {
	}
}
