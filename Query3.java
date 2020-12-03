package db_magic;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class Query3 {
	public static void main(String[] args) {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil?useUnicode=true&characterEncoding=UTF-8";
		String dbUser = "root";
		String dbPass = "235711";
		String create_table_statement = "CREATE TABLE IF NOT EXISTS magicfirm_information (magicfirmID int NOT NULL primary key AUTO_INCREMENT,"
		+ "password varchar(255) NOT NULL, " + "businessname varchar(255) NOT NULL, " + "adress varchar(255) NOT NULL, "+ "representative varchar(255) NOT NULL, " + "permissionclass int NOT NULL ," + "money int NOT NULL);";
		
		String insert_value_single =
				"Insert into magicfirm_information(magicfirmID,password,businessname,adress,representative,permissionclass,money) values (7000,'lebache1023','����ü','�����쵥�� ������ �߾�û', '����ư ������', '10', 16513225 )";

		// ���̺� Insert 
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


			System.out.println("����");
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