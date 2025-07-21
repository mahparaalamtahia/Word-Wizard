package wordwizard.WordWizard;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Label;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;
import java.io.IOException;
/**
 * FXML Controller class
 *
 * @author Mahpa
 */
public class LeaderboardController implements Initializable {

    @FXML
    private TableView<LeaderboardEntry> LeaderTable;
    @FXML
    private TableColumn<LeaderboardEntry, Integer> Rank;
    @FXML
    private TableColumn<LeaderboardEntry, String> UserName;
    @FXML
    private TableColumn<LeaderboardEntry, Integer> Point;
    @FXML
    private Button back;

    // ObservableList to hold leaderboard data
    private final ObservableList<LeaderboardEntry> leaderboardData = FXCollections.observableArrayList();

    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // Configure TableView columns
        Rank.setCellValueFactory(new PropertyValueFactory<>("rank"));
        UserName.setCellValueFactory(new PropertyValueFactory<>("username"));
        Point.setCellValueFactory(new PropertyValueFactory<>("points"));

        // Set placeholder for empty table
        LeaderTable.setPlaceholder(new Label("No leaderboard data available."));

        // Load data from database
        loadLeaderboardData();

        // Set data to TableView and refresh
        LeaderTable.setItems(leaderboardData);
        LeaderTable.refresh();

        // Handle back button click
        back.setOnAction(event -> {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("Home.fxml"));
                Parent root = loader.load();
                Stage stage = (Stage) back.getScene().getWindow();
                Scene scene = new Scene(root);
                stage.setScene(scene);
                stage.show();
            } catch (IOException e) {
                e.printStackTrace();
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setTitle("Navigation Error");
                alert.setHeaderText(null);
                alert.setContentText("Failed to load the Home screen.");
                alert.showAndWait();
            }
        });
    }

    private void loadLeaderboardData() {
        // Database connection parameters
        String url = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://127.0.0.1:3306/wordwizard?useSSL=false";
        String user = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
        String password = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "";

        // SQL query to calculate points (correct - wrong) per user
        String query = "SELECT username, " +
                      "SUM(CASE WHEN answer = 'correct' THEN 1 ELSE 0 END) AS correct_count, " +
                      "SUM(CASE WHEN answer = 'wrong' THEN 1 ELSE 0 END) AS wrong_count " +
                      "FROM results " +
                      "GROUP BY username " +
                      "ORDER BY (SUM(CASE WHEN answer = 'correct' THEN 1 ELSE 0 END) - SUM(CASE WHEN answer = 'wrong' THEN 1 ELSE 0 END)) DESC";

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setTitle("Driver Error");
            alert.setHeaderText(null);
            alert.setContentText("MySQL JDBC Driver not found. Please ensure it is included in the project.");
            alert.showAndWait();
            return;
        }

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            int rank = 1;
            int previousPoints = Integer.MAX_VALUE;
            int currentRank = 1;
            while (rs.next()) {
                String username = rs.getString("username");
                int correctCount = rs.getInt("correct_count");
                int wrongCount = rs.getInt("wrong_count");
                int points = correctCount - wrongCount;
                // Handle ties in ranking
                if (points < previousPoints) {
                    currentRank = rank;
                }
                leaderboardData.add(new LeaderboardEntry(currentRank, username, points));
                System.out.println("Added: Rank=" + currentRank + ", Username=" + username + ", Points=" + points);
                previousPoints = points;
                rank++;
            }
            if (leaderboardData.isEmpty()) {
                System.out.println("No data retrieved from the database.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setTitle("Database Error");
            alert.setHeaderText(null);
            alert.setContentText("Failed to load leaderboard data: " + e.getMessage());
            alert.showAndWait();
        }
    }

    // Model class for leaderboard entries
    public static class LeaderboardEntry {
        private final IntegerProperty rank;
        private final StringProperty username;
        private final IntegerProperty points;

        public LeaderboardEntry(int rank, String username, int points) {
            this.rank = new SimpleIntegerProperty(rank);
            this.username = new SimpleStringProperty(username);
            this.points = new SimpleIntegerProperty(points);
        }

        public int getRank() {
            return rank.get();
        }

        public IntegerProperty rankProperty() {
            return rank;
        }

        public String getUsername() {
            return username.get();
        }

        public StringProperty usernameProperty() {
            return username;
        }

        public int getPoints() {
            return points.get();
        }

        public IntegerProperty pointsProperty() {
            return points;
        }
    }
}