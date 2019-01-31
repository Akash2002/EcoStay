package com.ecostay;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class Login extends AppCompatActivity {

    private FirebaseAuth mAuth;
    private TextInputEditText usernameEditText, passwordEditText;
    private TextView newAccount;
    private Button login;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        mAuth = FirebaseAuth.getInstance();

        login = findViewById(R.id.btnLogin);
        usernameEditText = findViewById(R.id.emailEditText);
        passwordEditText = findViewById(R.id.passwordEditText);
        newAccount = findViewById(R.id.txtNewAccount);

        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.i("EditText",usernameEditText.getText().toString());
                Log.i("EditText",passwordEditText.getText().toString());
                Intent goToHome = new Intent(getApplicationContext(), Home.class);
                startActivity(goToHome);
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
