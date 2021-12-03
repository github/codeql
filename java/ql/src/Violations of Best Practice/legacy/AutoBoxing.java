Long sum = 0L; 
for (long k = 0; k < Integer.MAX_VALUE; k++) {
	sum += k;  // AVOID: Inefficient unboxing and reboxing of 'sum'
}