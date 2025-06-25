/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXML2.java to edit this template
 */
package wordwizard.WordWizard;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;
import javafx.stage.Stage;

/**
 *
 * @author Mahpa
 */
public class LoginController implements Initializable {
    
    @FXML
    private Label label;
    @FXML
    private Button LoginbuttonL;
    @FXML
    private TextField UserNameL;
    @FXML
    private TextField passwordIL;
    @FXML
    private Text UserNameT;
    @FXML
    private Text PasswordTS;
    @FXML
    private Text LoginHedding;
    @FXML
    private Button SignUpbuttonIL;
    
    
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
        SignUpbuttonIL.setOnAction(event -> {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("SignUp.fxml"));
                Parent root = loader.load();

                // Get current stage and set new scene
                Stage stage = (Stage) SignUpbuttonIL.getScene().getWindow();
                stage.setScene(new Scene(root));
                stage.setTitle("Login");
                stage.show();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }    
    
}
