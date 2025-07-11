/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package wordwizard.WordWizard;

/**
 *
 * @author Mahpa
 */
public class Session {
    private static String loggedInUsername;

    public static void setUsername(String Username) {
        loggedInUsername = Username;
        System.out.println("Session==============="+loggedInUsername);
    }

    public static String getUsername()
    {
        System.out.println("Session=>>>>>>>>>>>>>>>>>>>>"+loggedInUsername);
        return loggedInUsername;
    }
}
