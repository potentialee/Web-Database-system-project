package db_magic;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class Query {
	public static void main(String[] args) {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil?useUnicode=true&characterEncoding=UTF-8";
		String dbUser = "root";
		String dbPass = "235711";
		String create_table_statement = "CREATE TABLE IF NOT EXISTS magic_information  (MagicID int NOT NULL primary key AUTO_INCREMENT,"
		+ "MagicName varchar(255) NOT NULL, " + "MagicExplanation varchar(255) NOT NULL, " + "MagicClass int NOT NULL, " + "MagicAttribute varchar(255) NOT NULL,"
		+ "MagicType varchar(255) NOT NULL, " + "EffectiveDose int NOT NULL, " + "ManaConsume int NOT NULL," + "SellingPrice int NOT NULL, " + "MagicEffect varchar(255) NOT NULL," + "CreaterID int NOT NULL," + "foreign key(CreaterID) references magician_information(magicianid) on update cascade );";
		
		String insert_value_single =
				"Insert into magic_information(MagicID,MagicName,MagicExplanation,MagicClass,MagicAttribute,MagicType,EffectiveDose,ManaConsume,SellingPrice,MagicEffect,CreaterID) values (1000,'에너지 화살','순수 에너지를 발사한다.',1,'에너지','공격',20,21,250,'랜덤',3001)";

		// 테이블 Insert 
		String insert_value_statement = 
			"Insert into magic_information(MagicName,MagicExplanation,MagicClass,MagicAttribute,MagicType,EffectiveDose,ManaConsume,SellingPrice,MagicEffect, CreaterID) values (?,?,?,?,?,?,?,?,?,?)";

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
			String [] MagicName = { "화염구", "화염벽", "화염화살", "화염폭풍", "얼음화살", "얼음폭풍", "지진", "암석화살" };
			String [] MagicExplanation = { "화염구를 발사", "10미터 크기 화염벽 생성", "지정한 곳에 화염화살 발사", 
			"화염으로 이루어진 폭풍 생성", "지정한 곳에 얼음화살 발사", "냉기 가득한 폭풍 생성", "지진을 일으킴", "암석으로 된 화살 발사" };
			int [] MagicClass = { 3, 4, 2, 6, 2, 6, 3, 2 };
			String [] MagicAttribute = { "불", "불", "불", "불", "얼음", "얼음", "얼음", "대지"};
			String [] MagicType = { "공격", "방어", "공격", "공격", "공격", "공격", "공격", "공격" };
			int [] EffectiveDose = { 31, 45, 26, 66, 28, 69, 37, 26 };
			int [] ManaConsume = { 35, 125, 24, 457, 24, 480, 41, 31 };
			int [] SellingPrice = { 400, 670, 340, 1200, 380, 1270, 420, 370 };
			String [] MagicEffect = { "화상", "화상", "화상", "화상", "동상", "동상", "출혈", "출혈" };
			int[] CreaterID = {3000,3000,3007,3007,3010,3010,3001,3001};

			for (int i = 0; i < 8; i++) {
				preStmt.setString(1, MagicName[i]);
				preStmt.setString(2, MagicExplanation[i]);
				preStmt.setInt(3, MagicClass[i]);
				preStmt.setString(4, MagicAttribute[i]);
				preStmt.setString(5, MagicType[i]);
				preStmt.setInt(6, EffectiveDose[i]);
				preStmt.setInt(7, ManaConsume[i]);
				preStmt.setInt(8, SellingPrice[i]);
				preStmt.setString(9, MagicEffect[i]);
				preStmt.setInt(10, CreaterID[i]);
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