package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthResult;
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
                String user = usernameEditText.getText().toString();
                String pass = passwordEditText.getText().toString();

                if(user.equals("admin") && pass.equals("admin")){
                    Intent goAdminView = new Intent(getApplicationContext(), AdminView.class);
                    startActivity(goAdminView);
                }else{
                    mAuth.signInWithEmailAndPassword(user, pass).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull Task<AuthResult> task) {
                            if (task.isSuccessful()) {
                                Intent goToHome = new Intent(getApplicationContext(), Controller.class);
                                startActivity(goToHome);
                            }
                        }
                    });
                }
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
