package com.ecostay;

import android.content.Intent;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class CreateAccount extends AppCompatActivity {

    TextView name, email, phoneNumber, birthday, newPass, confirmPassword;
    Button createAccount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account);

        createAccount = findViewById(R.id.btnCreateAccount);
        createAccount.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                name = findViewById(R.id.txtName);
                email = findViewById(R.id.txtEmail);
                phoneNumber = findViewById(R.id.txtPhone);
                birthday = findViewById(R.id.txtBirthday);
                newPass = findViewById(R.id.txtPassNew);
                confirmPassword = findViewById(R.id.txtPassConfirm);

                Profile newProfile = new Profile(name.getText().toString(), email.getText().toString(), phoneNumber.getText().toString(), birthday.getText().toString(), newPass.getText().toString());

                Intent goLogin = new Intent(getApplicationContext(), Login.class);
                startActivity(goLogin);
            }
        });

    }
}
