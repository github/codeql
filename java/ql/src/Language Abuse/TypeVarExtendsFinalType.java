class Printer
{
	void print(List<? extends String> strings) {  // Unnecessary wildcard
		for (String s : strings)
			System.out.println(s);
	}
}