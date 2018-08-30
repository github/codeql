
public class Operations implements AutoCloseable {
	interface NoBodies {
		NoBodies append(String s);
	}
	
	interface NoBodiesSubtype extends NoBodies {
		NoBodies append(String s);
	}
	
	public Operations open() { return this; }
	public Operations create() { return this; }
	public boolean isOpen() { return true; }
	public void close() { return; }
	public boolean add(String s) { return true; }
	public boolean addAll(String...strings) { return true; }
	public Operations chain() { return this; }
	
	public void missingClose() {
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.close(); }
		{ Operations ops = open(); if (ops.isOpen()) ops.open(); }
	}
	
	public void missingAdd() {
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.add("something"); }
		{ Operations ops = create(); if (ops.isOpen()) ops.addAll("the", "things"); }
	}
	
	public void missingUse() {
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		System.out.println(this.toString());
		this.toString();
	}

	public void designedForChaining() {
		StringBuilder b = new StringBuilder();
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object use = b.append("a").append("b"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		{ Object unchainedUse = b.append("c"); }
		b.append("d");
	}
	
	public void noBodies() {
		NoBodiesSubtype t = null;
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object use = t.append("a").append("b"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		{ Object unchainedUse = t.append("c"); }
		t.append("d");
	}

	public void notMissingAfterAll(Operations ops) {
		ops = open(); ops.close();
	}
	
	private static class Builder {

		private int val;
		
		public Builder withVal(int val) {
			this.val = val;
			return this;
		}
		
		public String build() {
			return Integer.toString(val);
		}
	}
	
	public void missingBuild() {
		Builder builder = new Builder();
		String result;
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.build();
		result = builder.withVal(1).build();
	}

	public void testConn(java.sql.Connection conn) throws java.sql.SQLException {
		java.sql.PreparedStatement pstmt = null;
		java.sql.ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement("SELECT something FROM table");
			rs = pstmt.executeQuery();
			while(rs.next()) { // OK
			}
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
			pstmt.executeQuery().next();
		} finally {
		}
	}
	{
		String test = "test";
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		test = searchReplace(test);
		String test2 = "test2";
		test2 = searchReplace(test2); // OK (do not report methods called on their own result)
	}
	private String searchReplace(String s) {
		return s;
	}

	public void autoClose() {
		try(Operations ops = open()) {
			if (ops.isOpen()) ops.open();
		}
	}

}
