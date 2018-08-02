class LibraryClass {
public:
	void f() {
		...
		if (error) {
			abort(); //immediately terminates program, especially
			//bad since the class is in a library and not in the main
			//logic of the application.
		}
	}

	char* diff(string file1, string file2) {
		string command;
		command = "diff " + file1 + " " + file2;
		system(command); //call to system, may not be supported in all platforms
		...
		return cmd_out;
	}
};
