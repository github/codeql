public class NextFromIterator implements Iterator<String> {
	private int position = -1;
	private List<String> list = new ArrayList<String>() {{
		add("alpha"); add("bravo"); add("charlie"); add("delta"); add("echo"); add("foxtrot");
	}};
	
	public boolean hasNext() {
		return next() != null;  // BAD: Call to 'next'
	}
	
	public String next() {
		position++;
		return position < list.size() ? list.get(position) : null;
	}

	public void remove() {
		// ...
	}
	
	public static void main(String[] args) {
		NextFromIterator x = new NextFromIterator();
		while(x.hasNext()) {
			System.out.println(x.next());
		}
	}
}