package com.qunar.fresh.Supermarket.DataUtils;

import com.qunar.fresh.Supermarket.Model.Exhibit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.*;

/**
 * Created by Lumia_Saki on 15/4/2.
 */
public class DatabaseUtil {
    public static final String JDBC_DATABASE_PATH = "jdbc:mysql://localhost:3306/exhibit";
    public static final String JDBC_DATABASE_USER = "root";
    public static final String JDBC_DATABASE_PASSWORD = "";

    public static Logger logger = LoggerFactory.getLogger(DatabaseUtil.class);
    
    public static Exhibit exhibitByMajorValue(Integer majorValue) {
        Connection connection = null;
        Statement statement = null;

        Exhibit exhibit = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");

            connection = DriverManager.getConnection(JDBC_DATABASE_PATH, JDBC_DATABASE_USER, JDBC_DATABASE_PASSWORD);

            statement = connection.createStatement();

            ResultSet resultSet = statement.executeQuery("SELECT * FROM Exhibit WHERE majorValue = " + majorValue);

            while (resultSet.next()) {
                String artist = resultSet.getString("artist");
                String exhibitURL = resultSet.getString("exhibitURL");
                String exhibitName = resultSet.getString("exhibitName");

                exhibit = new Exhibit(majorValue, artist, exhibitURL, exhibitName);
            }

            connection.close();

        } catch (ClassNotFoundException e) {
            logger.error("class not found", e);
        } catch (SQLException e) {
            logger.error("sql error", e);
        }

        return exhibit;
    }
}
