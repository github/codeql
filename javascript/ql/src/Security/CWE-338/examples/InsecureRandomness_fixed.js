function securePassword() {
    // GOOD: the random suffix is cryptographically secure
    var suffix = window.crypto.getRandomValues(new Uint32Array(1))[0];
    var password = "myPassword" + suffix;
    
    // GOOD: if a random value between 0 and 1 is desired
    var secret = window.crypto.getRandomValues(new Uint32Array(1))[0] * Math.pow(2,-32);
}
