package com.ecostay;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.material.textfield.TextInputEditText;

public class Login extends AppCompatActivity {

    TextInputEditText username, password, newAccount;
    Button login;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        login = findViewById(R.id.btnLogin);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                username = findViewById(R.id.txtUsername);
                password = findViewById(R.id.txtPassword);

                Intent goHome = new Intent(getApplicationContext(), Home.class);
                startActivity(goHome);
            }
        });

        newAccount.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v){
                Intent goCreateAccount = new Intent(getApplicationContext(), CreateAccount.class);
                startActivity(goCreateAccount);
            }
        });
    }
}
