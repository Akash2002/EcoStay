package com.example.theo.tsaproject;

public class Profile {

    private String fullName;
    private String emailAddress;
    private String phoneNumber;
    private String dateOfBirth;
    private String password;

    public Profile(String inName, String inEmail, String inPhone, String inBirth, String inPass){
        fullName = inName;
        emailAddress = inEmail;
        phoneNumber = inPhone;
        dateOfBirth = inBirth;
        password = inPass;
    }
    //Probably will delete most of these later
    //Here just in case
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getPassword() {   //Security risk!!!
        return password;
    }

    public void setPassword(String password) {  //Security risk!!!
        this.password = password;
    }
}
