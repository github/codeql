function bitIsSet(x, n) {
	return (x & (1<<n)) > 0;
}

console.log(bitIsSet(-1, 31)); // prints 'false'