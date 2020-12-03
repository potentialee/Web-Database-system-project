package db_magic;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class Query2 {
	public static void main(String[] args) {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil?useUnicode=true&characterEncoding=UTF-8";
		String dbUser = "root";
		String dbPass = "235711";
		String create_table_statement = "CREATE TABLE IF NOT EXISTS ingredient_information (ingredientID int NOT NULL primary key AUTO_INCREMENT,"
		+ "ingredientname varchar(255) NOT NULL, " + "origin varchar(255) NOT NULL, " + "kinds varchar(255) NOT NULL, " + "price int NOT NULL);";
		
		String insert_value_single =
				"Insert into ingredient_information(ingredientID,ingredientname,origin,kinds,price) values (5000,'불의 결정','펠헤임','정수', 4000 )";

		// 테이블 Insert 
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
