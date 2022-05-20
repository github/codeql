public class CloseSqlGood {
	public static void runQuery(Connection con, String query) throws SQLException {
		try (Statement stmt = con.createStatement();
				ResultSet rs = stmt.executeQuery(query)) {
			while (rs.next()) {
				// process result set
			}
		}
	}
}