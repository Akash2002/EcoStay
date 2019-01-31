package com.ecostay;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;

public class CreateAccount extends AppCompatActivity {

    FirebaseAuth mAuth;

    private TextView name, email, phoneNumber, birthday, newPass, confirmPassword;
    private Button createAccount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account);

        mAuth = FirebaseAuth.getInstance();

        name = findViewById(R.id.txtName);
        email = findViewById(R.id.txtEmail);
        phoneNumber = findViewById(R.id.txtPhone);
        birthday = findViewById(R.id.txtBirthday);
        newPass = findViewById(R.id.txtPassNew);
        confirmPassword = findViewById(R.id.txtPassConfirm);


        createAccount = findViewById(R.id.btnCreateAccount);
        createAccount.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){

                Profile newProfile = new Profile(name.getText().toString(), email.getText().toString(), phoneNumber.getText().toString(), birthday.getText().toString(), newPass.getText().toString());

                mAuth.createUserWithEmailAndPassword(email.getText().toString(), newPass.getText().toString())
                    .addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull Task<AuthResult> task) {
                            if(task.isSuccessful()){
                                System.out.println("Worked");
                            }else{
                                System.out.println("NOt");
                            }
                        }
                    });

                Intent goLogin = new Intent(getApplicationContext(), Login.class);
                startActivity(goLogin);
            }
        });

    }
}
