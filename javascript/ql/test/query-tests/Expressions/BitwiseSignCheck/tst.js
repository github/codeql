function bitIsSet(x, n) {
	return (x & (1<<n)) > 0; // $ Alert
}

console.log(bitIsSet(-1, 31)); // prints 'false'

(x & 3) > 0; // this is fine


x = -1;
console.log((x | 0) > (0)); // prints 'false'

console.log((x >>> 0) > 0); // $ Alert - prints 'true'


console.log((x << 16 >> 16) > 0); // prints 'false'


(x & 256) > 0;

(x & 0x100000000) > 0; // $ Alert