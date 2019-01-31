package com.ecostay;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.google.android.material.textfield.TextInputEditText;

import org.w3c.dom.Text;

public class ViewProfile extends AppCompatActivity {

    TextInputEditText name, email, phone, password;
    Profile userProfile;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_profile);

        userProfile = new Profile("Test", "test@test.com", "0000000000", "1/1/11", "test");

        name = findViewById(R.id.txtNameDisplay);
        email = findViewById(R.id.txtEmailDisplay);
        phone = findViewById(R.id.txtPhoneDisplay);

        name.setText(userProfile.getName());
        email.setText(userProfile.getEmail());
        phone.setText(userProfile.getPhoneNumber());
    }
}
