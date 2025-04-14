fn get_average(values:&[i32]) -> f64 {
	let mut sum = 0;
	let mut average = 0.0; // BAD: unused value

	for v in values {
		sum += v;
	}

	average = sum as f64 / values.len() as f64;
	return average;
}
