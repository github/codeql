fn get_average(values:&[i32]) -> f64 {
	let mut sum = 0;
	let average;

	for v in values {
		sum += v;
	}

	average = sum as f64 / values.len() as f64;
	return average;
}
