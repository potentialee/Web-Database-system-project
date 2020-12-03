package db_magic;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class Query10 {
	public static void main(String[] args) {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil?useUnicode=true&characterEncoding=UTF-8";
		String dbUser = "root";
		String dbPass = "235711";
		String create_table_statement = "CREATE TABLE IF NOT EXISTS customer_mbuy_information (magicfirmid int NOT NULL,"
 + "magicid int NOT NULL," + "amount int NOT NULL," + "foreign key(magicfirmid) references magicfirm_information(magicfirmid) on update cascade on delete cascade," + " foreign key(magicid) references magic_information(magicid) on update cascade on delete cascade,"+ "constraint amount_value_unique unique (amount),"+"constraint magic_value_unique unique (magicid));";
		

		Statement stmt = null;
		Connection conn = null;

		try {
			String driver = "org.mariadb.jdbc.Driver";
			try {
				Class.forName(driver);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}

			conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
			stmt = conn.createStatement();
			stmt.executeUpdate(create_table_statement);


			System.out.println("성공");
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				stmt.close();
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}