public class CloseSql {
	public static void runQuery(Connection con, String query) throws SQLException {
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery(query);
		while (rs.next()) {
			// process result set
		}
	}
}