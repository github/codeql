//wrong: could evaluate to 0 (false) due to rounding errors
23.42f == 23.42

//wrong: could evaluate to 1 (true) due to rounding errors
1000000000.0f == 1000000001.0f

//correct: use a margin of error to check equality
fabs(f1 - f2) < EPSILON
