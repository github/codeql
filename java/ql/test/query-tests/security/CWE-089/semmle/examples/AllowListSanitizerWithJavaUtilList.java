// Test cases for CWE-089 (SQL injection and Java Persistence query injection)
// http://cwe.mitre.org/data/definitions/89.html
package test.cwe089.semmle.tests;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.function.Consumer;

class AllowListSanitizerWithJavaUtilList {
	public static Connection connection;
	public static final List<String> goodAllowList1 = List.of("allowed1", "allowed2", "allowed3");
	public static final List<String> goodAllowList2 = Collections.unmodifiableList(Arrays.asList("allowed1"));
	public static final List<String> goodAllowList3;
	public static final List<String> goodAllowList4;
	public static final List<String> goodAllowList5;
	public static final List<String> badAllowList1 = List.of("allowed1", "allowed2", getNonConstantString());
	public static final List<String> badAllowList2 = Collections.unmodifiableList(Arrays.asList("allowed1", getNonConstantString()));
	public static final List<String> badAllowList3;
	public static final List<String> badAllowList4;
	public static List<String> badAllowList6 = List.of("allowed1", "allowed2", "allowed3");
	public final List<String> goodAllowList7 = List.of("allowed1", "allowed2", "allowed3");

	static {
    	goodAllowList3 = List.of("allowed1", "allowed2", "allowed3");
    	goodAllowList4 = Collections.unmodifiableList(Arrays.asList("allowed1", "allowed2"));
    	badAllowList3 = List.of(getNonConstantString(), "allowed2", "allowed3");
    	badAllowList4 = Collections.unmodifiableList(Arrays.asList("allowed1", getNonConstantString()));
		goodAllowList5 = new ArrayList<String>();
		goodAllowList5.add("allowed1");
		goodAllowList5.add("allowed2");
		goodAllowList5.add("allowed3");
	}

	public static String getNonConstantString() {
		return String.valueOf(System.currentTimeMillis());
	}

	public static void main(String[] args) throws IOException, SQLException {
		badAllowList6 = List.of("allowed1", getNonConstantString(), "allowed3");
		testStaticFields(args);
		testLocal(args);
		var x = new AllowListSanitizerWithJavaUtilList();
		x.testNonStaticFields(args);
		testMultipleSources(args);
		testEscape(args);
	}

	private static void testStaticFields(String[] args) throws IOException, SQLException {
		String tainted = args[1];
		// GOOD: an allowlist is used with constant strings
		if(goodAllowList1.contains(tainted.toLowerCase())){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// GOOD: an allowlist is used with constant strings
		if(goodAllowList2.contains(tainted.toUpperCase())){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// GOOD: an allowlist is used with constant strings
		if(goodAllowList3.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// GOOD: an allowlist is used with constant strings
		if(goodAllowList4.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowlist is used with constant strings
		if(badAllowList1.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowlist is used with constant strings
		if(badAllowList2.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowlist is used with constant strings
		if(badAllowList3.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowlist is used with constant strings
		if(badAllowList4.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// GOOD: an allowlist is used with constant strings
		if(goodAllowList5.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: the allowlist is in a non-final field
		if(badAllowList6.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
	}

	private void testNonStaticFields(String[] args) throws IOException, SQLException {
		String tainted = args[0];
		// GOOD: the allowlist is in a non-static field
		if(goodAllowList7.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
	}

	private static void testLocal(String[] args) throws IOException, SQLException {
		String tainted = args[1];
		// GOOD: an allowlist is used with constant strings
		{
			List<String> allowlist = List.of("allowed1", "allowed2", "allowed3");
			if(allowlist.contains(tainted.toLowerCase())){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowlist is used but one of the entries is not a compile-time constant
		{
			List<String> allowlist = List.of("allowed1", "allowed2", args[2]);
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// GOOD: an allowlist is used with constant strings
		{
			String[] allowedArray = {"allowed1", "allowed2", "allowed3"};
			List<String> allowlist = List.of(allowedArray);
			if(allowlist.contains(tainted.toUpperCase())){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowlist is used but one of the entries is not a compile-time constant
		{
			String[] allowedArray = {"allowed1", "allowed2", args[2]};
			List<String> allowlist = List.of(allowedArray);
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// GOOD: an allowlist is used with constant strings
		{
			List<String> allowlist = Collections.unmodifiableList(Arrays.asList("allowed1"));
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowlist is used but one of the entries is not a compile-time constant
		{
			List<String> allowlist = Collections.unmodifiableList(Arrays.asList("allowed1", "allowed2", args[2]));
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// GOOD: an allowlist is used with constant strings
		{
			String[] allowedArray = {"allowed1", "allowed2", "allowed3"};
			List<String> allowlist = Collections.unmodifiableList(Arrays.asList(allowedArray));
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowlist is used but one of the entries is not a compile-time constant
		{
			String[] allowedArray = {"allowed1", "allowed2", args[2]};
			List<String> allowlist = Collections.unmodifiableList(Arrays.asList(allowedArray));
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// GOOD: an allowlist is used with constant string
		{
			List<String> allowlist = new ArrayList<String>();
			allowlist.add("allowed1");
			allowlist.add("allowed2");
			allowlist.add("allowed3");
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowlist is used but one of the entries is not a compile-time constant
		{
			List<String> allowlist = new ArrayList<String>();
			allowlist.add("allowed1");
			allowlist.add(getNonConstantString());
			allowlist.add("allowed3");
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowlist is used but it contains a non-compile-time constant element
		{
			List<String> allowlist = new ArrayList<String>();
			allowlist.add("allowed1");
			addNonConstantStringDirectly(allowlist);
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
	}

	private static void testMultipleSources(String[] args) throws IOException, SQLException {
		String tainted = args[1];
		boolean b = args[2] == "True";
		{
			// BAD: an allowlist is used which might contain constant strings
			List<String> allowlist = new ArrayList<String>();
			allowlist.add("allowed1");
			if (b) {
				allowlist.add(getNonConstantString());
			}
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		{
			// BAD: an allowlist is used which might contain constant strings
			List<String> allowlist = b ? goodAllowList1 : badAllowList1;
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		{
			// BAD: an allowlist is used which might contain constant strings
			List<String> allowlist = b ? goodAllowList1 : List.of("allowed1", "allowed2", args[2]);;
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
	}

	private static void testEscape(String[] args) throws IOException, SQLException {
		String tainted = args[1];
		boolean b = args[2] == "True";
		{
			// BAD: an allowlist is used which contains constant strings
			List<String> allowlist = new ArrayList<String>();
			addNonConstantStringViaLambda(e -> allowlist.add(e));
			if(allowlist.contains(tainted)){ // missing result
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
	}

	private static void addNonConstantStringDirectly(List<String> list) {
		list.add(getNonConstantString());
	}

	private static void addNonConstantStringViaLambda(Consumer<String> adder) {
		adder.accept(getNonConstantString());
	}

}
