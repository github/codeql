public enum Result {
	SUCCESS,
	FAILURE,
	ERROR
}

public Result runOperation(String value) {
	if (value == 1) {
		return SUCCESS;
	} else {
		return FAILURE;
	}
}

public static void main(String[] args) {
	Result operationResult = runOperation(args[0]);
	if (operationResult == Result.ERROR) {
		exit(1);
	} else {
		exit(0);
	}

}