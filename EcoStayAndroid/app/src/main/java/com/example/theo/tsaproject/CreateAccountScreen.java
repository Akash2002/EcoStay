package com.example.theo.tsaproject;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.HashMap;
import java.util.Map;

public class CreateAccountScreen extends AppCompatActivity {

    TextView firstNameTxt, lastNameTxt, emailTxt, phoneTxt,  birthdayTxt, passTxt, confirmPassTxt;
    Button submitBtn;
    FirebaseDatabase database;
    DatabaseReference ref;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account_screen);
    }

    @Override
    protected void onStart(){
        super.onStart();

        database = FirebaseDatabase.getInstance();

        firstNameTxt = findViewById(R.id.FirstNameText);
        lastNameTxt = findViewById(R.id.LastNameText);
        emailTxt = findViewById(R.id.EmailText);
        phoneTxt = findViewById(R.id.PhoneText);
        birthdayTxt = findViewById(R.id.BirthdayText);
        passTxt = findViewById(R.id.PasswordText);
        confirmPassTxt = findViewById(R.id.ConfirmPassText);

        submitBtn = findViewById(R.id.button3);
        submitBtn.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                String name = firstNameTxt.getText().toString()  +  lastNameTxt.getText().toString();
                Profile temp = new Profile(name, emailTxt.getText().toString(), phoneTxt.getText().toString(), birthdayTxt.getText().toString(), passTxt.getText().toString());
                Map<String, Profile> user = new HashMap<>();
                user.put(name, temp);
                ref = database.getReference("https://test-e9d07.firebaseio.com/theo");
                ref.setValue("test");

                //ref = database.getReference("https://ecotourism-7983b.firebaseio.com/"+emailTxt.getText().toString());

            }
        });


    }

}
