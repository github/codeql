package main

// autoformat-ignore (we intentionally test unusual capitalisations of 0B, 0O and other such prefixes)

const (
	b1 = 0b1011
	b2 = 0B1011
	o1 = 0o660
	o2 = 0O660
	h1 = 0x1.p-1021
	h2 = 0X1.p-1021
	s1 = 1_000_000
	s2 = 0b_0101_0110
	s3 = 3.1415_9265
)
