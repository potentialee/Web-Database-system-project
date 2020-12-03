package db_magic;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class Query1 {
	public static void main(String[] args) {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil?useUnicode=true&characterEncoding=UTF-8";
		String dbUser = "root";
		String dbPass = "235711";
		String create_table_statement = "CREATE TABLE IF NOT EXISTS Magician_Information  (MagicianID int NOT NULL primary key AUTO_INCREMENT,"
		+ "Password varchar(255) NOT NULL, " + "MagicianName varchar(255) NOT NULL , " + "Age int NOT NULL , " + "Tribe varchar(255) NOT NULL ,"
		+ "Hometown varchar(255) NOT NULL, " + "Job varchar(255) NOT NULL, " + "MagicClass int NOT NULL," + "MagicAttribute  varchar(255) NOT NULL , " + "ManaCount int NOT NULL , " + "Money int NOT NULL );";
		
		String insert_value_single =
				"Insert into magician_information(MagicianID,Password,MagicianName,Age,Tribe,Hometown,Job,MagicClass,MagicAttribute,ManaCount,Money) values (3000, '1q2w3e4r', '찬일_전', 112, '하프엘프', '네버윈터', '데이터베이스관리자', 10, '화염', 1250236, 12315462 )";

		// 테이블 Insert 
		String insert_value_statement = 
			"Insert into magician_information(Password,MagicianName,Age,Tribe,Hometown,Job,MagicClass,MagicAttribute,ManaCount,Money) values (?,?,?,?,?,?,?,?,?,?)";

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
			String [] Password = { "a1b2c3d4", "1q2w3e4r", "1q2w3e4r!", "abcedf1122", "bico1230", "imoen0092", "ed10048282", "dorai2003", "lassad8282", "n110029aa" };
			String [] MagicianName = { "엘민스터", "드리즈트도어덴", "민스크", "자헤이라", "비코니아", "이모엔", "에드윈", "도른일-칸", "라사드", "니라" };
			int [] Age = { 1021, 2135, 34, 702, 230, 23, 61, 102, 43, 443  };
			String [] Tribe = { "인간", "드로우", "인간", "하프엘프", "드로우", "인간", "인간", "하프오크", "인간", "하프엘프" };
			String [] Hometown = { "섀도우데일", "섀도우데일", "소드코스트", "테디르", "언더다크", "소드코스트", "나쉬켈", "소드코스트", "나쉬켈", "베레고스트"  };
			String [] Job = { "마법의회 장로", "모험가", "광전사", "드루이드", "클레릭", "씨프", "해결사", "팔라딘", "선소울몽크", "와일드메이지" };
			int [] MagicClass = { 10, 8, 1, 4, 5, 3, 7, 1, 1, 7 };
			String [] MagicAttribute = { "대지", "암흑", "에너지", "나무", "암흑", "에너지", "화염", "에너지", "에너지", "얼음" };
			int [] ManaCount = { 10000020, 1315321, 100, 333420, 410000, 43200, 1270000, 213, 99, 1281427 };
			int [] Money = { 1365356, 9465352, 21320, 112300, 543232, 32100, 465613, 64650, 1200, 333120 };

			for (int i = 0; i < 10; i++) {
				preStmt.setString(1, Password[i]);
				preStmt.setString(2, MagicianName[i]);
				preStmt.setInt(3, Age[i]);
				preStmt.setString(4, Tribe[i]);
				preStmt.setString(5, Hometown[i]);
				preStmt.setString(6, Job[i]);
				preStmt.setInt(7, MagicClass[i]);
				preStmt.setString(8, MagicAttribute[i]);
				preStmt.setInt(9, ManaCount[i]);
				preStmt.setInt(10, Money[i]);
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
