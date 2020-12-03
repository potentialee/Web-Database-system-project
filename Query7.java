package db_magic;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class Query7 {
	public static void main(String[] args) {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil?useUnicode=true&characterEncoding=UTF-8";
		String dbUser = "root";
		String dbPass = "235711";
		String create_table_statement = "CREATE TABLE IF NOT EXISTS instock_information (magicfirmid int NOT NULL,"
 + "ingredientid int NOT NULL," + "instock int NOT NULL," + "foreign key(magicfirmid) references magicfirm_information(magicfirmid) on update cascade on delete cascade," + " foreign key(ingredientid) references ingredient_information(ingredientid) on update cascade on delete cascade);";
		
		String insert_value_single =
				"Insert into instock_information(magicfirmid,ingredientid,instock) values (7000, 5000 , 24 )";

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
			stmt.executeUpdate(insert_value_single);


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