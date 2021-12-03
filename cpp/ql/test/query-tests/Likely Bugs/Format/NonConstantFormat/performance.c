// This is a regression test. It must be run with the `--optimize` flag to the
// test driver.

#define d0(p) p,
#define d1(p) d0(p"0") d0(p"1") d0(p"2") d0(p"3") d0(p"4") d0(p"5")
#define d2(p) d1(p"0") d1(p"1") d1(p"2") d1(p"3") d1(p"4") d1(p"5")
#define d3(p) d2(p"0") d2(p"1") d2(p"2") d2(p"3") d2(p"4") d2(p"5")
#define d4(p) d3(p"0") d3(p"1") d3(p"2") d3(p"3") d3(p"4") d3(p"5")
#define d5(p) d4(p"0") d4(p"1") d4(p"2") d4(p"3") d4(p"4") d4(p"5")
#define d6(p) d5(p"0") d5(p"1") d5(p"2") d5(p"3") d5(p"4") d5(p"5")
#define d7(p) d6(p"0") d6(p"1") d6(p"2") d6(p"3") d6(p"4") d6(p"5")

// This array contains 6^7 = 279,936 different strings.
const char *arr[] = {
    d7("")
};
