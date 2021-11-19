package fr.univtln.bruno;

import lombok.extern.java.Log;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Map;
import java.util.Optional;

@Log
public class App {

    public static void main(String[] args) throws ClassNotFoundException {
        Map<String, String> env = System.getenv();
        final String DB_NAME = Optional.ofNullable(env.get("DB_NAME")).orElse("demodb");
        final String DB_URL = Optional.ofNullable(env.get("DB_URL")).orElse("jdbc:postgresql://localhost:5432/" + DB_NAME);
        final String DB_USER = Optional.ofNullable(env.get("DB_USER")).orElse("demodba");
        final String DB_PASSWORD = Optional.ofNullable(env.get("DB_PASSWORD")).orElse("secret");

        log.info(DB_URL+" "+DB_USER+" "+DB_PASSWORD);

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            DatabaseMetaData database = connection.getMetaData();
            log.info(database.getDatabaseProductName() + " " + database.getDatabaseProductVersion());
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
