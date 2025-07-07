/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package wordwizard.WordWizard;

import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.util.ResourceBundle;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.stage.Stage;

/**
 * FXML Controller class
 *
 * @author Mahpa
 */


public class AdminPanelController implements Initializable {

    @FXML private TextField word;
    @FXML private Hyperlink logout;
    @FXML private TableColumn<ObservableList<String>, String> WordID;
    @FXML private TableColumn<ObservableList<String>, String> words;
    @FXML private TableView<ObservableList<String>> wordTable;
    @FXML private Button AddWord;
    @FXML private Button EditWord;
    @FXML private Button DeleteWord;

    private ObservableList<ObservableList<String>> wordList = FXCollections.observableArrayList();
    private String selectedWordID = null;

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        setupTable();
        loadWords();
        
        logout.setOnAction(event -> {
    try {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("DashBoard.fxml"));
        Parent root = loader.load();
        Stage stage = (Stage) logout.getScene().getWindow();
        stage.setScene(new Scene(root));
        stage.setTitle("Admin Login");
        stage.show();
    } catch (IOException e) {
        e.printStackTrace();
        showAlert(Alert.AlertType.ERROR, "Failed to load login screen.");
    }
});

        wordTable.getSelectionModel().selectedItemProperty().addListener((obs, oldSelection, newSelection) -> {
            if (newSelection != null) {
                selectedWordID = newSelection.get(0);
                word.setText(newSelection.get(1));
            }
        });

        AddWord.setOnAction(event -> {
            String wordText = word.getText().trim();
            if (wordText.isEmpty()) {
                showAlert(Alert.AlertType.WARNING, "Word cannot be empty.");
                return;
            }

            try (Connection conn = getConnection()) {
                String checkQuery = "SELECT * FROM words WHERE word = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.setString(1, wordText);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    showAlert(Alert.AlertType.INFORMATION, "Word already exists.");
                } else {
                    String insertQuery = "INSERT INTO words (word) VALUES (?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setString(1, wordText);
                    insertStmt.executeUpdate();

                    showAlert(Alert.AlertType.INFORMATION, "Word added successfully.");
                    word.clear();
                    loadWords();
                }

                rs.close();
                checkStmt.close();
            } catch (Exception e) {
                e.printStackTrace();
                showAlert(Alert.AlertType.ERROR, "Database error.");
            }
        });

        EditWord.setOnAction(event -> {
            String newWord = word.getText().trim();
            if (selectedWordID == null) {
                showAlert(Alert.AlertType.WARNING, "Please select a word to edit.");
                return;
            }
            if (newWord.isEmpty()) {
                showAlert(Alert.AlertType.WARNING, "Word cannot be empty.");
                return;
            }

            try (Connection conn = getConnection()) {
                String updateQuery = "UPDATE words SET word = ? WHERE wordID = ?";
                PreparedStatement stmt = conn.prepareStatement(updateQuery);
                stmt.setString(1, newWord);
                stmt.setString(2, selectedWordID);
                stmt.executeUpdate();

                showAlert(Alert.AlertType.INFORMATION, "Word updated.");
                word.clear();
                selectedWordID = null;
                loadWords();
            } catch (Exception e) {
                e.printStackTrace();
                showAlert(Alert.AlertType.ERROR, "Update failed.");
            }
        });

        DeleteWord.setOnAction(event -> {
            if (selectedWordID == null) {
                showAlert(Alert.AlertType.WARNING, "Please select a word to delete.");
                return;
            }

            try (Connection conn = getConnection()) {
                String deleteQuery = "DELETE FROM words WHERE wordID = ?";
                PreparedStatement stmt = conn.prepareStatement(deleteQuery);
                stmt.setString(1, selectedWordID);
                stmt.executeUpdate();

                showAlert(Alert.AlertType.INFORMATION, "Word deleted.");
                word.clear();
                selectedWordID = null;
                loadWords();
            } catch (Exception e) {
                e.printStackTrace();
                showAlert(Alert.AlertType.ERROR, "Delete failed.");
            }
        });
    }

    private void setupTable() {
        WordID.setCellValueFactory(data -> new SimpleStringProperty(data.getValue().get(0)));
        words.setCellValueFactory(data -> new SimpleStringProperty(data.getValue().get(1)));
        wordTable.setItems(wordList);
    }

    private void loadWords() {
        wordList.clear();
        try (Connection conn = getConnection()) {
            String query = "SELECT * FROM words";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ObservableList<String> row = FXCollections.observableArrayList();
                row.add(String.valueOf(rs.getInt("wordID")));
                row.add(rs.getString("word"));
                wordList.add(row);
            }

            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/wordwizard", "root", "");
    }

    private void showAlert(Alert.AlertType type, String msg) {
        Alert alert = new Alert(type);
        alert.setTitle("Message");
        alert.setHeaderText(null);
        alert.setContentText(msg);
        alert.showAndWait();
    }
}