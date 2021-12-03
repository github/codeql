class SupportedExternalTaint {
	public static void main(String[] args) throws Exception {
		StringBuilder builder = new StringBuilder();
		builder.append("foo");
		builder.toString();
	}
}
