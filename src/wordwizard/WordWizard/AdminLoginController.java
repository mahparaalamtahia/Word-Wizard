/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package wordwizard.WordWizard;

import java.net.URL;
import java.sql.*;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
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



public class AdminLoginController implements Initializable {

    @FXML
    private TextField username;
    @FXML
    private PasswordField password;
    @FXML
    private Button Login;
    @FXML
    private Label loginWarning;

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        Login.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                String user = username.getText().trim();
                String pass = password.getText().trim();
                if (user.isEmpty() || pass.isEmpty()) {
                    loginWarning.setText("⚠️ Username or Password is empty.");
                    return;
                }   String dbURL = "jdbc:mysql://localhost:3306/wordwizard"; // make sure this DB name is correct
                String dbUser = "root";
                String dbPass = "";
                try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass)) {
                    String query = "SELECT * FROM admin WHERE UserName = ? AND Password = ?";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setString(1, user);
                    stmt.setString(2, pass);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        loginWarning.setText("✅ Login successful!");
                        // Load the next screen (Admin Dashboard)
                        Parent root = FXMLLoader.load(AdminLoginController.this.getClass().getResource("AdminPanel.fxml"));
                        Stage stage = (Stage) Login.getScene().getWindow();
                        stage.setScene(new Scene(root));
                        stage.setTitle("Word Wizard Admin");
                        stage.show();
                    } else {
                        loginWarning.setText("❌ Invalid username or password.");
                    }
                    rs.close();
                    stmt.close();
                }catch (Exception e) {
                    e.printStackTrace();
                    loginWarning.setText("❌ Login failed due to DB error.");
                }
            }
        });
    }
}