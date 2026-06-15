// semmle-extractor-options: --expect_errors

void test_float_double1(float f, double d) {
    float r1 = f * f; // GOOD
    float r2 = f * d; // GOOD
    double r3 = f * f; // BAD
    double r4 = f * d; // GOOD

    float f1 = fabsf(f * f); // GOOD
    float f2 = fabsf(f * d); // GOOD
    double f3 = fabs(f * f); // BAD [NOT DETECTED]
    double f4 = fabs(f * d); // GOOD
}

double fabs(double f);
float fabsf(float f);

void test_float_double2(float f, double d) {
    float r1 = f * f; // GOOD
    float r2 = f * d; // GOOD
    double r3 = f * f; // BAD
    double r4 = f * d; // GOOD

    float f1 = fabsf(f * f); // GOOD
    float f2 = fabsf(f * d); // GOOD
    double f3 = fabs(f * f); // BAD [NOT DETECTED]
    double f4 = fabs(f * d); // GOOD
}
