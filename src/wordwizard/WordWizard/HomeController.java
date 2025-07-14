package wordwizard.WordWizard;

import java.io.IOException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.Hyperlink;
import javafx.scene.layout.AnchorPane;
import javafx.scene.text.Text;
import javafx.stage.Stage;

/**
 * FXML Controller class
 *
 * @author Mahpa
 */
public class HomeController implements Initializable {

    @FXML
    private Text textW;
    @FXML
    private Hyperlink LOGOUT;
    @FXML
    private AnchorPane AccID;
    @FXML
    private Text History;
    @FXML
    private Button Start;
    @FXML
    private Text CorrectGuess;
    @FXML
    private Text WrongGuess;

    private final String DB_URL = "jdbc:mysql://localhost:3306/wordwizard?useSSL=false&serverTimezone=UTC";
    private final String DB_USER = "root";
    private final String DB_PASS = "";

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // Check for null FXML elements
        if (CorrectGuess == null || WrongGuess == null || textW == null) {
            System.err.println("FXML injection failed: CorrectGuess, WrongGuess, or textW is null");
            showErrorAlert("Initialization Error", "One or more UI elements failed to load. Check Home.fxml.");
            return;
        }

        // Set up LOGOUT button action
        LOGOUT.setOnAction(event -> {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("Login.fxml"));
                Parent root = loader.load();
                Stage stage = (Stage) LOGOUT.getScene().getWindow();
                stage.setScene(new Scene(root));
                stage.setTitle("Login");
                stage.show();
                // Clear session on logout
                Session.setUsername(null);
            } catch (IOException e) {
                e.printStackTrace();
                showErrorAlert("Navigation Error", "Failed to load Login screen.");
            }
        });

        // Set up Start button action
        Start.setOnAction(event -> {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("GameDisplay.fxml"));
                Parent root = loader.load();
                Stage stage = (Stage) Start.getScene().getWindow();
                stage.setScene(new Scene(root));
                stage.setTitle("Game Display");
                stage.show();
            } catch (IOException e) {
                e.printStackTrace();
                showErrorAlert("Navigation Error", "Failed to load Game Display screen.");
            }
        });

        // Get the current username from the session
        Session session = new Session();
        String username = session.getUsername();
        System.out.println("Username from session: '" + (username != null ? username : "null") + "'");

        if (username == null || username.trim().isEmpty()) {
            System.err.println("No valid username found in session. Setting default values.");
            textW.setText("Welcome, Guest");
            CorrectGuess.setText("Correct: 0");
            WrongGuess.setText("Wrong: 0");
            showErrorAlert("Session Error", "No valid username found. Please log in again.");
            return;
        }

        setProfileName(username);
        updateGuessCounts(username.trim()); // Trim to avoid whitespace issues
    }

    public void setProfileName(String name) {
        textW.setText("Welcome, " + (name != null ? name : "Guest"));
        System.out.println("Profile name set to: 'Welcome, " + (name != null ? name : "Guest") + "'");
    }

    private void updateGuessCounts(String username) {
        System.out.println("Querying database for username: '" + username + "'");

        // SQL queries to count correct and wrong answers
        String correctQuery = "SELECT COUNT(*) AS count FROM results WHERE username = ? AND answer = 'correct'";
        String wrongQuery = "SELECT COUNT(*) AS count FROM results WHERE username = ? AND answer = 'wrong'";
        String debugQuery = "SELECT username, answer FROM results WHERE username = ?"; // Debug query to check data

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            System.out.println("Database connection established successfully.");

            // Debug: Check all records for the username
            PreparedStatement debugStmt = conn.prepareStatement(debugQuery);
            debugStmt.setString(1, username);
            ResultSet debugRs = debugStmt.executeQuery();
            System.out.println("Debug: Results for username '" + username + "':");
            boolean hasRecords = false;
            while (debugRs.next()) {
                hasRecords = true;
                System.out.println("  - Username: '" + debugRs.getString("username") + "', Answer: '" + debugRs.getString("answer") + "'");
            }
            if (!hasRecords) {
                System.out.println("  - No records found for username '" + username + "'");
            }

            // Query for correct answers
            PreparedStatement correctStmt = conn.prepareStatement(correctQuery);
            correctStmt.setString(1, username);
            ResultSet correctRs = correctStmt.executeQuery();
            int correctCount = 0;
            if (correctRs.next()) {
                correctCount = correctRs.getInt("count");
                System.out.println("Correct count for '" + username + "': " + correctCount);
            } else {
                System.out.println("No correct results found for '" + username + "'");
            }
            CorrectGuess.setText("" + correctCount);

            // Query for wrong answers
            PreparedStatement wrongStmt = conn.prepareStatement(wrongQuery);
            wrongStmt.setString(1, username);
            ResultSet wrongRs = wrongStmt.executeQuery();
            int wrongCount = 0;
            if (wrongRs.next()) {
                wrongCount = wrongRs.getInt("count");
                System.out.println("Wrong count for '" + username + "': " + wrongCount);
            } else {
                System.out.println("No wrong results found for '" + username + "'");
            }
            WrongGuess.setText(""+wrongCount);

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
            CorrectGuess.setText("0");
            WrongGuess.setText("0");
            showErrorAlert("Database Error", "Failed to retrieve guess counts: " + e.getMessage());
        }
    }

    private void showErrorAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }
}