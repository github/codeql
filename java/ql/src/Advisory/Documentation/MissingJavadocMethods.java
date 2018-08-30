/**
 * Extracts the user's name from the input arguments.
 *
 * Precondition: 'args' should contain at least one element, the user's name.
 *
 * @param  args            the command-line arguments.
 * @return                 the user's name (the first command-line argument).
 * @throws NoNameException if 'args' contains no element.
 */
public static String getName(String[] args) throws NoNameException {
	if(args.length == 0) {
		throw new NoNameException();
	} else {
		return args[0];
	}
}