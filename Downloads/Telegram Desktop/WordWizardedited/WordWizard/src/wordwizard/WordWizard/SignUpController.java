/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package wordwizard.WordWizard;

import java.io.IOException;
import java.net.URL;
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
public class SignUpController implements Initializable {

    @FXML
    private TextField fullnameIS;
    @FXML
    private TextField usernameIS;
    @FXML
    private TextField gmailIs;
    @FXML
    private TextField PasswordIS;
    @FXML
    private TextField CpasswordIS;
    @FXML
    private Text usernameTS;
    @FXML
    private Text fullnameTS;
    @FXML
    private Text gmailTS;
    @FXML
    private Text PasswordTS;
    @FXML
    private Text CpasswordTS;
    @FXML
    private Button LoginSB;
    @FXML
    private Button SignUpBS;
    @FXML
    private Text SignUpHedding;

    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        
        // TODO
        
        LoginSB.setOnAction(event -> {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("Login.fxml"));
                Parent root = loader.load();

                // Get current stage and set new scene
                Stage stage = (Stage) LoginSB.getScene().getWindow();
                stage.setScene(new Scene(root));
                stage.setTitle("Login");
                stage.show();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }    
    
}
