package com.ecostay;

public class Profile {

    private String name;
    private String email;
    private String phoneNumber;
    private String birthday;
    private String password; //To be deleted

    public Profile(String name, String email, String phoneNumber, String birthday, String password) {
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.birthday = birthday;
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public String getBirthday() {
        return birthday;
    }
}
