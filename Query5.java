package db_magic;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class Query5 {
	public static void main(String[] args) {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil?useUnicode=true&characterEncoding=UTF-8";
		String dbUser = "root";
		String dbPass = "235711";
		String create_table_statement = "CREATE TABLE IF NOT EXISTS belongto_information (magicianid int NOT NULL,"
 + "magicfirmid int  NOT NULL,"  + "foreign key(magicianid) references magician_information(magicianid) on update cascade on delete cascade," + " foreign key(magicfirmid) references magician_information(magicfirmid) on update cascade on delete cascade);";
		
		String insert_value_single =
				"Insert into magic_information(magicianid,magicfirmid) values (3002, 7000)";

		// 테이블 Insert 
		String insert_value_statement = 
			"Insert into magic_information(magicianid,magicfirmid) values (?,?)";

		Statement stmt = null;
		PreparedStatement preStmt = null;
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
			stmt.executeUpdate(insert_value_single);

			preStmt = conn. prepareStatement(insert_value_statement);

			// 테이블 실 데이터
			// String [] MagicID = { "Fire001", "Fire002","Fire003","Fire004", "Ice001", "Ice002", "earth001", "earth002" };
			int [] magicianid = { 3005, 3011 };
			int [] magicfirmid = { 7000, 7000  };

			for (int i = 0; i < 2; i++) {
				preStmt.setInt(1, magicianid[i]);
				preStmt.setInt(2, magicfirmid[i]);
				preStmt.executeUpdate();
				preStmt.clearParameters();
			}


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