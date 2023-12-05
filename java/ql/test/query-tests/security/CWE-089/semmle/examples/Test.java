


// Test cases for CWE-089 (SQL injection and Java Persistence query injection)
// http://cwe.mitre.org/data/definitions/89.html
package test.cwe089.semmle.tests;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;





enum Category {
	FloorWax, Topping, Biscuits
}

abstract class Test {
	public static Connection connection;
	public static int categoryId;
	public static String categoryName;
	public static String tableName;

	private static void tainted(String[] args) throws IOException, SQLException {
		// BAD: the category might have SQL special characters in it
		{
			String category = args[1];
			Statement statement = connection.createStatement();
			String query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ category + "' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(query1);
		}
		// BAD: don't use user input when building a prepared call
		{
			String id = args[1];
			String query2 = "{ call get_product_by_id('" + id + "',?,?,?) }";
			PreparedStatement statement = connection.prepareCall(query2);
			ResultSet results = statement.executeQuery();
		}
		// BAD: don't use user input when building a prepared query
		{
			String category = args[1];
			String query3 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ category + "' ORDER BY PRICE";
			PreparedStatement statement = connection.prepareStatement(query3);
			ResultSet results = statement.executeQuery();
		}
		// BAD: an injection using a StringBuilder instead of string append 
		{
			String category = args[1];
			StringBuilder querySb = new StringBuilder();
			querySb.append("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='");
			querySb.append(category);
			querySb.append("' ORDER BY PRICE");
			String querySbToString = querySb.toString();
			Statement statement = connection.createStatement();
			ResultSet results = statement.executeQuery(querySbToString);
		}
		// BAD: executeUpdate
		{
			String item = args[1];
			String price = args[2];
			Statement statement = connection.createStatement();
			String query = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
			int count = statement.executeUpdate(query);
		}
		// BAD: executeUpdate
		{
			String item = args[1];
			String price = args[2];
			Statement statement = connection.createStatement();
			String query = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
			long count = statement.executeLargeUpdate(query);
		}

		// OK: validate the input first
		{
			String category = args[1];
			Validation.checkIdentifier(category);
			Statement statement = connection.createStatement();
			String query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ category + "' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(query1);
		}
	}
	
	private static void unescaped() throws IOException, SQLException {
		// BAD: the category might have SQL special characters in it
		{
			Statement statement = connection.createStatement();
			String queryFromField = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ categoryName + "' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(queryFromField);
		}
		// BAD: unescaped code using a StringBuilder 
		{
			StringBuilder querySb = new StringBuilder();
			querySb.append("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='");
			querySb.append(categoryName);
			querySb.append("' ORDER BY PRICE");
			String querySbToString = querySb.toString();
			Statement statement = connection.createStatement();
			ResultSet results = statement.executeQuery(querySbToString);
		}
		// BAD: a StringBuilder with appends of + operations 
		{
			StringBuilder querySb2 = new StringBuilder();
			querySb2.append("SELECT ITEM,PRICE FROM PRODUCT ");
			querySb2.append("WHERE ITEM_CATEGORY='" + categoryName + "' ");
			querySb2.append("ORDER BY PRICE");
			String querySb2ToString = querySb2.toString();
			Statement statement = connection.createStatement();
			ResultSet results = statement.executeQuery(querySb2ToString);
		}
	}
	
	private static void good(String[] args) throws IOException, SQLException {
		// GOOD: use a prepared query
		{
			String category = args[1];
			String query2 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY=? ORDER BY PRICE";
			PreparedStatement statement = connection.prepareStatement(query2);
			statement.setString(1, category);
			ResultSet results = statement.executeQuery();
		}		
	}
	
	private static void controlledStrings()  throws IOException, SQLException {
		// GOOD: integers cannot have special characters in them
		{
			Statement statement = connection.createStatement();
			String queryWithInt = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ categoryId + "' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(queryWithInt);
		}

		// GOOD: enum names are safe
		{
			Statement statement = connection.createStatement();
			String queryWithEnum = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ Category.Topping + "' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(queryWithEnum);
		}

		// GOOD: enum with toString called on it is safe
		{
			Statement statement = connection.createStatement();
			String queryWithEnumToString = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ Category.Topping.toString() + "' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(queryWithEnumToString);
		}

		// GOOD: class names are okay
		{
			Statement statement = connection.createStatement();
			String queryWithClassName = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ Test.class.getName() + "' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(queryWithClassName);
		}

		// GOOD: class names are okay
		{
			Statement statement = connection.createStatement();
			String queryWithClassSimpleName = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ Test.class.getSimpleName() + "' ORDER BY PRICE";
			ResultSet results = statement
					.executeQuery(queryWithClassSimpleName);
		}
		// GOOD: certain toString() methods are okay
		{
			Statement statement = connection.createStatement();
			String queryWithDoubleToString = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
					+ Double.toString(categoryId) + "' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(queryWithDoubleToString);
		}
	}
	
	private static void tableNames(String[] args) throws IOException, SQLException {
		// GOOD: table names cannot be replaced by a wildcard
		{
			Statement statement = connection.createStatement();
			String queryWithTableName = "SELECT ITEM,PRICE FROM " + tableName
					+ " WHERE ITEM_CATEGORY='Biscuits' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(queryWithTableName);
		}
		{
			Statement statement = connection.createStatement();
			String queryWithTableName2 = "SELECT ITEM,PRICE FROM " + tableName;
			ResultSet results = statement.executeQuery(queryWithTableName2);
		}
		{
			Statement statement = connection.createStatement();
			String queryWithTableName3 = "SELECT ITEM,PRICE" + " FROM " + tableName;
			ResultSet results = statement.executeQuery(queryWithTableName3);
		}

		// BAD: a table name that is user input
		{
			String userTabName = args[1];
			Statement statement = connection.createStatement();
			String queryWithUserTableName = "SELECT ITEM,PRICE FROM "
					+ userTabName
					+ " WHERE ITEM_CATEGORY='Biscuits' ORDER BY PRICE";
			ResultSet results = statement.executeQuery(queryWithUserTableName);
		}
	}

	private static void bindingVars(String[] args) throws IOException, SQLException {
                // BAD: the category might have SQL special characters in it
                {
                        String category = args[1];
                        Statement statement = connection.createStatement();
			String prefix = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='";
			String suffix = "' ORDER BY PRICE";
			switch(prefix) {
				case String prefixAlias when prefix.length() > 10 -> statement.executeQuery(prefixAlias + category + suffix);
				default -> { }
			}
		}
	}

	public static void main(String[] args) throws IOException, SQLException {
		tainted(args);
		unescaped();
		good(args);
		controlledStrings();
		tableNames(args);
		bindingVars(args);
	}
}

