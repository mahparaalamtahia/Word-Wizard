/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXML2.java to edit this template
 */
package wordwizard.WordWizard;

import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.util.ResourceBundle;
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

public class LoginController implements Initializable {

    @FXML private Button LoginbuttonL;
    @FXML private TextField UserNameL;
    @FXML private TextField passwordIL;
    @FXML private Text Warnigs;
    @FXML private Button SignUpbuttonIL;

    private final String DB_URL = "jdbc:mysql://localhost:3306/wordwizard";
    private final String DB_USER = "root";
    private final String DB_PASS = ""; // Add your DB password if any

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        SignUpbuttonIL.setOnAction(event -> {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("SignUp.fxml"));
                Parent root = loader.load();
                Stage stage = (Stage) SignUpbuttonIL.getScene().getWindow();
                stage.setScene(new Scene(root));
                stage.setTitle("Sign Up");
                stage.show();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        LoginbuttonL.setOnAction(event -> handleLogin());
    }

    private void handleLogin() {
        String username = UserNameL.getText().trim();
        String password = passwordIL.getText();

        if (username.isEmpty() || password.isEmpty()) {
            Warnigs.setText("Please enter both username and password.");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            String query = "SELECT * FROM user WHERE user_name = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password); // Hash this in real applications

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                // Login successful — Load Dashboard
                FXMLLoader loader = new FXMLLoader(getClass().getResource("Home.fxml"));
                Parent root = loader.load();

                // Optional: pass username to dashboard
                HomeController controller = loader.getController();
                controller.setProfileName(username);  // Ensure setProfileName() is in DashBoardController

                Stage stage = (Stage) LoginbuttonL.getScene().getWindow();
                stage.setScene(new Scene(root));
                stage.setTitle("Dashboard");
                stage.show();
            } else {
                Warnigs.setText("Invalid username or password.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            Warnigs.setText("Database error.");
        } catch (IOException e) {
            e.printStackTrace();
            Warnigs.setText("Failed to load dashboard.");
        }
    }
}