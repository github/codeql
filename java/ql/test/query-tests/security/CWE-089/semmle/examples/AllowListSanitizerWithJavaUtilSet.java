// Test cases for CWE-089 (SQL injection and Java Persistence query injection)
// http://cwe.mitre.org/data/definitions/89.html
package test.cwe089.semmle.tests;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashSet;
import java.util.List;
import java.util.Arrays;
import java.util.Collections;
import java.util.Set;

class AllowListSanitizerWithJavaUtilSet {
	public static Connection connection;
	public static final Set<String> goodAllowSet1 = Set.of("allowed1", "allowed2", "allowed3");
	public static final Set<String> goodAllowSet2 = Collections.unmodifiableSet(new HashSet<String>(Arrays.asList("allowed1","allowed2")));
	public static final Set<String> goodAllowSet3;
	public static final Set<String> goodAllowSet4;
	public static final Set<String> badAllowSet1 = Set.of("allowed1", "allowed2", getNonConstantString());
	public static final Set<String> badAllowSet2 = Collections.unmodifiableSet(new HashSet<String>(Arrays.asList("allowed1", getNonConstantString())));
	public static final Set<String> badAllowSet3;
	public static final Set<String> badAllowSet4;
	public static final Set<String> badAllowSet5;
	public static Set<String> badAllowSet6 = Set.of("allowed1", "allowed2", "allowed3");
	public final Set<String> badAllowSet7 = Set.of("allowed1", "allowed2", "allowed3");

	static {
    	goodAllowSet3 = Set.of("allowed1", "allowed2", "allowed3");
    	goodAllowSet4 = Collections.unmodifiableSet(new HashSet<String>(Arrays.asList("allowed1", "allowed2")));
    	badAllowSet3 = Set.of(getNonConstantString(), "allowed2", "allowed3");
    	badAllowSet4 = Collections.unmodifiableSet(new HashSet<String>(Arrays.asList("allowed1", getNonConstantString())));
		badAllowSet5 = new HashSet<String>();
		badAllowSet5.add("allowed1");
		badAllowSet5.add("allowed2");
		badAllowSet5.add("allowed3");
	}

	public static String getNonConstantString() {
		return String.valueOf(System.currentTimeMillis());
	}

	public static void main(String[] args) throws IOException, SQLException {
		badAllowSet6 = Set.of("allowed1", getNonConstantString(), "allowed3");
		testStaticFields(args);
		testLocal(args);
		var x = new AllowListSanitizerWithJavaUtilSet();
		x.testNonStaticFields(args);
	}

	private static void testStaticFields(String[] args) throws IOException, SQLException {
		String tainted = args[1];
		// GOOD: an allowSet is used with constant strings
		if(goodAllowSet1.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// GOOD: an allowSet is used with constant strings
		if(goodAllowSet2.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// GOOD: an allowSet is used with constant strings
		if(goodAllowSet3.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// GOOD: an allowSet is used with constant strings
		if(goodAllowSet4.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowSet is used with constant strings
		if(badAllowSet1.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowSet is used with constant strings
		if(badAllowSet2.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowSet is used with constant strings
		if(badAllowSet3.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowSet is used with constant strings
		if(badAllowSet4.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: an allowSet is used with constant strings
		if(badAllowSet5.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
		// BAD: the allowSet is in a non-final field
		if(badAllowSet6.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
	}

	private void testNonStaticFields(String[] args) throws IOException, SQLException {
		String tainted = args[0];
		// BAD: the allowSet is in a non-static field
		if(badAllowSet7.contains(tainted)){
			String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ tainted + "' ORDER BY PRICE";
			ResultSet results = connection.createStatement().executeQuery(query);
		}
	}

	private static void testLocal(String[] args) throws IOException, SQLException {
			String tainted = args[1];
		// GOOD: an allowSet is used with constant strings
		{
			Set<String> allowSet = Set.of("allowed1", "allowed2", "allowed3");
			if(allowSet.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowSet is used but one of the entries is not a compile-time constant
		{
			Set<String> allowSet = Set.of("allowed1", "allowed2", args[2]);
			if(allowSet.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// GOOD: an allowSet is used with constant strings
		{
			String[] allowedArray = {"allowed1", "allowed2", "allowed3"};
			Set<String> allowSet = Set.of(allowedArray);
			if(allowSet.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowSet is used but one of the entries is not a compile-time constant
		{
			String[] allowedArray = {"allowed1", "allowed2", args[2]};
			Set<String> allowSet = Set.of(allowedArray);
			if(allowSet.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// GOOD: an allowlist is used with constant strings
		{
			Set<String> allowlist = Collections.unmodifiableSet(new HashSet<>(Arrays.asList("allowed1")));
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowlist is used but one of the entries is not a compile-time constant
		{
			Set<String> allowlist = Collections.unmodifiableSet(new HashSet<>(Arrays.asList("allowed1", "allowed2", args[2])));
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// GOOD: an allowlist is used with constant strings
		{
			String[] allowedArray = {"allowed1", "allowed2", "allowed3"};
			Set<String> allowlist = Collections.unmodifiableSet(new HashSet<>(Arrays.asList(allowedArray)));
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowlist is used but one of the entries is not a compile-time constant
		{
			String[] allowedArray = {"allowed1", "allowed2", args[2]};
			Set<String> allowlist = Collections.unmodifiableSet(new HashSet<>(Arrays.asList(allowedArray)));
			if(allowlist.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// GOOD: an allowSet is used with constant string
		{
			Set<String> allowSet = new HashSet<String>();
			allowSet.add("allowed1");
			allowSet.add("allowed2");
			allowSet.add("allowed3");
			if(allowSet.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
		// BAD: an allowSet is used but one of the entries is not a compile-time constant
		{
			Set<String> allowSet = new HashSet<String>();
			allowSet.add("allowed1");
			allowSet.add(getNonConstantString());
			allowSet.add("allowed3");
			if(allowSet.contains(tainted)){
				String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
						+ tainted + "' ORDER BY PRICE";
				ResultSet results = connection.createStatement().executeQuery(query);
			}
		}
	}

}
