package wordwizard.WordWizard;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.ResourceBundle;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;

/**
 * FXML Controller class for Word Wizard game
 *
 * @author Mahpa
 */
public class GameDisplayController implements Initializable {

    @FXML
    private Text Hints;
    @FXML
    private TextField answer;
    @FXML
    private Button submit;
    @FXML
    private Button TryAgain;
    @FXML
    private Text Hints1;
    @FXML
    private Text Hints2;
    @FXML
    private Text Hint1Label;
    @FXML
    private Text Hint2Label;
    @FXML
    private Text Hint3Label;
    @FXML
    private ComboBox<String> levelSelector;
    @FXML
    private HBox hint1Box;
    @FXML
    private HBox hint2Box;
    @FXML
    private HBox hint3Box;
    @FXML
    private Text WorngAns;

    private String currentWord;
    private int currentWordID;
    private String username;
    private Connection connection;

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // Initialize database connection
        initializeDatabase();

        // Get username from session
        Session session = new Session();
        username = session.getUsername();
        System.out.println("Username: " + username); // Debug log

        // Initialize level selector
        levelSelector.setItems(FXCollections.observableArrayList("Hard", "Normal", "Easy"));
        levelSelector.setValue("Easy"); // Default to Easy
        levelSelector.setOnAction(event -> updateHintVisibility());

        // Load a new word and hints
        loadNewWord();

        // Set up button actions
        submit.setOnAction(event -> checkAnswer());
        TryAgain.setOnAction(event -> tryAgain());
    }

    private void initializeDatabase() {
        try {
            // Database credentials
            String dbUrl = "jdbc:mysql://localhost:3306/wordwizard?useSSL=false";
            String dbUser = "root";
            String dbPassword = "";
            connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            System.out.println("Database connected successfully");
        } catch (SQLException e) {
            e.printStackTrace();
            setHintText("Error connecting to database: " + e.getMessage(), Hints);
        }
    }

    private void loadNewWord() {
        try {
            // Get all word IDs that the user hasn't answered correctly
            List<Integer> availableWordIDs = getAvailableWordIDs();
            if (availableWordIDs.isEmpty()) {
                setHintText("Congratulations! You've answered all words correctly!", Hints);
                submit.setDisable(true);
                TryAgain.setDisable(true);
                System.out.println("No available words to display");
                return;
            }

            // Select a random word ID
            Random random = new Random();
            currentWordID = availableWordIDs.get(random.nextInt(availableWordIDs.size()));
            System.out.println("Selected wordID: " + currentWordID); // Debug log

            // Get word and all hints
            String query = "SELECT word, Hint1, Hint2, Hint3 FROM words WHERE wordID = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, currentWordID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                WorngAns.setText("");
                currentWord = rs.getString("word");
                String hint1 = rs.getString("Hint1");
                String hint2 = rs.getString("Hint2");
                String hint3 = rs.getString("Hint3");
                System.out.println("Word: " + currentWord + ", Hints: " + hint1 + ", " + hint2 + ", " + hint3); // Debug log

                // Set hints to respective Text fields, checking for null or empty
                setHintText(hint1 != null && !hint1.trim().isEmpty() ? hint1 : "No hint available", Hints1);
                setHintText(hint2 != null && !hint2.trim().isEmpty() ? hint2 : "No hint available", Hints2);
                setHintText(hint3 != null && !hint3.trim().isEmpty() ? hint3 : "No hint available", Hints);

                // Update hint visibility based on level
                updateHintVisibility();
            } else {
                setHintText("Error: Word not found for ID " + currentWordID, Hints);
                System.out.println("No word found for wordID: " + currentWordID);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            setHintText("Error loading word: " + e.getMessage(), Hints);
            System.out.println("SQL Error in loadNewWord: " + e.getMessage());
        }
    }

    private void updateHintVisibility() {
        String level = levelSelector.getValue();
        Platform.runLater(() -> {
            // Reset visibility
            hint1Box.setVisible(false);
            hint2Box.setVisible(false);
            hint3Box.setVisible(false);

            // Set visibility based on level
            switch (level) {
                case "Hard":
                    hint1Box.setVisible(true);
                    break;
                case "Normal":
                    hint1Box.setVisible(true);
                    hint2Box.setVisible(true);
                    break;
                case "Easy":
                    hint1Box.setVisible(true);
                    hint2Box.setVisible(true);
                    hint3Box.setVisible(true);
                    break;
            }
        });
    }

    private List<Integer> getAvailableWordIDs() throws SQLException {
        List<Integer> availableIDs = new ArrayList<>();
        
        // Get all word IDs
        String query = "SELECT wordID FROM words";
        PreparedStatement stmt = connection.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            availableIDs.add(rs.getInt("wordID"));
        }
        System.out.println("Available word IDs: " + availableIDs); // Debug log

        // Remove word IDs that user has answered correctly
        query = "SELECT wordID FROM results WHERE username = ? AND answer = 'correct'";
        stmt = connection.prepareStatement(query);
        stmt.setString(1, username);
        rs = stmt.executeQuery();
        List<Integer> correctIDs = new ArrayList<>();
        while (rs.next()) {
            correctIDs.add(rs.getInt("wordID"));
        }
        availableIDs.removeAll(correctIDs);
        System.out.println("Correctly answered word IDs: " + correctIDs); // Debug log
        System.out.println("Remaining available word IDs: " + availableIDs); // Debug log

        return availableIDs;
    }

    private void checkAnswer() {
        String userAnswer = answer.getText().trim().toLowerCase();
        if (userAnswer.isEmpty()) {
            setHintText("Please enter an answer", Hints);
            return;
        }

        boolean isCorrect = userAnswer.equals(currentWord.toLowerCase());
        System.out.println("User answer: " + userAnswer + ", Correct word: " + currentWord + ", Is correct: " + isCorrect); // Debug log

        try {
            // Save result to database
            String query = "INSERT INTO results (wordID, username, answer) VALUES (?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, currentWordID);
            stmt.setString(2, username);
            stmt.setString(3, isCorrect ? "correct" : "wrong");
            stmt.executeUpdate();
            System.out.println("Result saved: wordID=" + currentWordID + ", username=" + username + ", answer=" + (isCorrect ? "correct" : "wrong")); // Debug log

            // Display result and handle next steps
            if (isCorrect) {
                setHintText("Correct! Loading new word...", Hints);
                answer.clear();
                loadNewWord();
            } else {
                WorngAns.setText("Incorrect. Try again or click 'Try Again' for a new word.");
                TryAgain.setDisable(false);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            setHintText("Error saving result: " + e.getMessage(), Hints);
            System.out.println("SQL Error in checkAnswer: " + e.getMessage());
        }
    }

    private void tryAgain() {
        answer.clear();
        TryAgain.setDisable(true);
        setHintText("Loading new word...", Hints);
        loadNewWord();
        System.out.println("Try Again triggered, new word loaded"); // Debug log
    }

    // Helper method to update hint text on JavaFX thread
    private void setHintText(String text, Text target) {
        Platform.runLater(() -> target.setText(text));
    }
}