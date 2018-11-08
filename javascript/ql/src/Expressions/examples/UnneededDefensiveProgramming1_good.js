function cleanupLater(delay, cb) {
    setTimeout(function() {
        cleanupNow();
        // GOOD: no need to guard the invocation
        cb();
    }, delay)
}

cleanupLater(function(){console.log("Cleanup done")});
