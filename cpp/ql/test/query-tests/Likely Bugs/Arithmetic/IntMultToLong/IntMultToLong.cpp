int i = 2000000000;
long j = i * i; // BAD
long k = (long) i * i; // GOOD
long l = (long) (i * i); // permitted as the conversion is explicit
long m = static_cast<long> (i) * i; // GOOD
long n = static_cast<long> (i * i); // permitted as the conversion is explicit
