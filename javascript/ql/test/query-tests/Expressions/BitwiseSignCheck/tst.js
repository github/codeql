function bitIsSet(x, n) {
	return (x & (1<<n)) > 0;
}

console.log(bitIsSet(-1, 31)); // prints 'false'

(x & 3) > 0; // this is fine

// OK
x = -1;
console.log((x | 0) > (0)); // prints 'false'

// NOT OK
console.log((x >>> 0) > 0); // prints 'true'

// OK
console.log((x << 16 >> 16) > 0); // prints 'false'

// OK
(x & 256) > 0;

// NOT OK
(x & 0x100000000) > 0;