/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
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
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
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

        // Load a new word and hint
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
            setHintText("Error connecting to database: " + e.getMessage());
        }
    }

    private void loadNewWord() {
        try {
            // Get all word IDs that the user hasn't answered correctly
            List<Integer> availableWordIDs = getAvailableWordIDs();
            if (availableWordIDs.isEmpty()) {
                setHintText("Congratulations! You've answered all words correctly!");
                submit.setDisable(true);
                TryAgain.setDisable(true);
                System.out.println("No available words to display");
                return;
            }

            // Select a random word ID
            Random random = new Random();
            currentWordID = availableWordIDs.get(random.nextInt(availableWordIDs.size()));
            System.out.println("Selected wordID: " + currentWordID); // Debug log

            // Get word and random hint
            String query = "SELECT word, Hint1, Hint2, Hint3 FROM words WHERE wordID = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, currentWordID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                currentWord = rs.getString("word");
                String hint1 = rs.getString("Hint1");
                String hint2 = rs.getString("Hint2");
                String hint3 = rs.getString("Hint3");
                System.out.println("Word: " + currentWord + ", Hints: " + hint1 + ", " + hint2 + ", " + hint3); // Debug log

                // Ensure hints are not null or empty
                List<String> hints = new ArrayList<>();
                if (hint1 != null && !hint1.trim().isEmpty()) hints.add(hint1);
                if (hint2 != null && !hint2.trim().isEmpty()) hints.add(hint2);
                if (hint3 != null && !hint3.trim().isEmpty()) hints.add(hint3);

                if (hints.isEmpty()) {
                    setHintText("No valid hints available for this word");
                    System.out.println("No valid hints found for wordID: " + currentWordID);
                    return;
                }

                // Select random hint
                String selectedHint = hints.get(random.nextInt(hints.size()));
                setHintText(selectedHint);
                System.out.println("Displaying hint: " + selectedHint);
            } else {
                setHintText("Error: Word not found for ID " + currentWordID);
                System.out.println("No word found for wordID: " + currentWordID);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            setHintText("Error loading word: " + e.getMessage());
            System.out.println("SQL Error in loadNewWord: " + e.getMessage());
        }
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
            setHintText("Please enter an answer");
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
                setHintText("Correct! Loading new word...");
                answer.clear();
                loadNewWord();
            } else {
                setHintText("Incorrect. Try again or click 'Try Again' for a new word.");
                TryAgain.setDisable(false);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            setHintText("Error saving result: " + e.getMessage());
            System.out.println("SQL Error in checkAnswer: " + e.getMessage());
        }
    }

    private void tryAgain() {
        answer.clear();
        TryAgain.setDisable(true);
        setHintText("Loading new word...");
        loadNewWord();
        System.out.println("Try Again triggered, new word loaded"); // Debug log
    }

    // Helper method to update hint text on JavaFX thread
    private void setHintText(String text) {
        Platform.runLater(() -> Hints.setText(text));
    }
}