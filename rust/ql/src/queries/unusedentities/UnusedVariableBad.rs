fn get_sum(values:&[i32]) -> i32 {
	let mut sum = 0;
	let mut average; // BAD: unused variable

	for v in values {
		sum += v;
	}

	return sum;
}
