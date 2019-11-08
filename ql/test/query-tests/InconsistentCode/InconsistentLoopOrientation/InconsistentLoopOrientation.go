package main

func zeroOutExceptBad(a []int, lower int, upper int) {
	// zero out everything below index `lower`
	for i := lower - 1; i >= 0; i-- {
		a[i] = 0
	}

	// zero out everything above index `upper`
	for i := upper + 1; i < len(a); i-- { // NOT OK
		a[i] = 0
	}
}
