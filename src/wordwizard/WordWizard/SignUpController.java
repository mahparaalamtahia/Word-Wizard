/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package wordwizard.WordWizard;
import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;
import javafx.stage.Stage;

/**
 * FXML Controller class
 *
 * @author Mahpa
 */

public class SignUpController implements Initializable {

    @FXML private TextField fullnameIS;
    @FXML private TextField usernameIS;
    @FXML private TextField gmailIs;
    @FXML private TextField PasswordIS;
    @FXML private TextField CpasswordIS;
    @FXML private Text warnigT;
    @FXML private Button LoginSB;
    @FXML private Button SignUpBS;

    private final String DB_URL = "jdbc:mysql://localhost:3306/wordwizard";
    private final String DB_USER = "root";
    private final String DB_PASS = ""; // Update if you use a password

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        LoginSB.setOnAction(event -> {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("Login.fxml"));
                Parent root = loader.load();
                Stage stage = (Stage) LoginSB.getScene().getWindow();
                stage.setScene(new Scene(root));
                stage.setTitle("Login");
                stage.show();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        SignUpBS.setOnAction(event -> handleSignUp());
    }

    private void handleSignUp() {
        String fullName = fullnameIS.getText().trim();
        String userName = usernameIS.getText().trim();
        String gmail = gmailIs.getText().trim();
        String password = PasswordIS.getText();
        String confirmPassword = CpasswordIS.getText();

        if (fullName.isEmpty() || userName.isEmpty() || gmail.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            warnigT.setText("All fields are required.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            warnigT.setText("Passwords do not match.");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            // Check if gmail exists
            String emailQuery = "SELECT * FROM user WHERE gmail = ?";
            PreparedStatement emailStmt = conn.prepareStatement(emailQuery);
            emailStmt.setString(1, gmail);
            ResultSet emailResult = emailStmt.executeQuery();
            if (emailResult.next()) {
                warnigT.setText("Email is already registered.");
                return;
            }

            // Check if username exists
            String userQuery = "SELECT * FROM user WHERE user_name = ?";
            PreparedStatement userStmt = conn.prepareStatement(userQuery);
            userStmt.setString(1, userName);
            ResultSet userResult = userStmt.executeQuery();
            if (userResult.next()) {
                warnigT.setText("Username is already taken.");
                return;
            }

            // Insert new user
            String insertQuery = "INSERT INTO user (gmail, full_name, user_name, password) VALUES (?, ?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setString(1, gmail);
            insertStmt.setString(2, fullName);
            insertStmt.setString(3, userName);
            insertStmt.setString(4, password); // You should hash the password in a real app
            insertStmt.executeUpdate();

            FXMLLoader loader = new FXMLLoader(getClass().getResource("Login.fxml"));
            Parent root = null;
            try {
                root = loader.load();
            } catch (IOException ex) {
                Logger.getLogger(SignUpController.class.getName()).log(Level.SEVERE, null, ex);
            }
            Stage stage = (Stage) SignUpBS.getScene().getWindow();
            stage.setScene(new Scene(root));
            stage.setTitle("Login");
            stage.show();
            
        } catch (SQLException e) {
            e.printStackTrace();
            warnigT.setText("Database error. Please try again.");
        }
    }
}
