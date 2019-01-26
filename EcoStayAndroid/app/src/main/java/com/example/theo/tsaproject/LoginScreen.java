package com.example.theo.tsaproject;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import org.w3c.dom.Text;

public class LoginScreen extends AppCompatActivity {

    TextView userTxt, passTxt, createAccount;
    Button submitBtn;
    FirebaseDatabase firebaseReference;
    DatabaseReference ref;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_screen);

        userTxt = findViewById(R.id.editText);
        passTxt = findViewById(R.id.editText2);
        createAccount = findViewById(R.id.textView);

        firebaseReference = FirebaseDatabase.getInstance();

        submitBtn = findViewById(R.id.button);
        submitBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String username = userTxt.getText().toString();
                String password = passTxt.getText().toString();

                ref = firebaseReference.getReference(username + "/password");

                if(/*password.equals(ref)*/true) {
                    Intent login = new Intent(getApplicationContext(), HomeScreen.class);
                    login.putExtra("com.example.theo.tsaproject.account", username);
                    startActivity(login);
                }

            }
        });

        createAccount.setOnClickListener(new View.OnClickListener() {
           @Override
           public void onClick(View v) {
               Intent newAccount = new Intent(getApplicationContext(), CreateAccountScreen.class);
               startActivity(newAccount);
           }
        });
    }
}
