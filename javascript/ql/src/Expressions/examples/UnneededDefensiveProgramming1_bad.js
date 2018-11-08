function cleanupLater(delay, cb) {
    setTimeout(function() {
        cleanup();
        if (cb) { // BAD: useless check, `cb` is always truthy
            cb();
        }
    }, delay)
}

cleanupLater(1000, function(){console.log("Cleanup done")});
