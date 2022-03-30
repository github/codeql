/*properties log,Log*/

logger.log("Starting...");
for (var i=0; i<max; ++i) {
	logger.log("Iteration #" + i);
	doSomething(i);
}
logger.Log("Done.");