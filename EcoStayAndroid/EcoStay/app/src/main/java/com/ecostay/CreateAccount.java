package com.ecostay;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class CreateAccount extends AppCompatActivity {

    FirebaseAuth mAuth;
    FirebaseUser currentUser;
    FirebaseDatabase database;
    DatabaseReference ref;

    private TextView name, email, phoneNumber, birthday, newPass, confirmPassword;
    private Button createAccount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account);

        mAuth = FirebaseAuth.getInstance();
        database = FirebaseDatabase.getInstance();


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

                mAuth.createUserWithEmailAndPassword(email.getText().toString(), newPass.getText().toString())
                    .addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull Task<AuthResult> task) {
                            if(task.isSuccessful()){
                                Profile newProfile = new Profile(name.getText().toString(), email.getText().toString(), phoneNumber.getText().toString(), birthday.getText().toString(), newPass.getText().toString());

                                currentUser = mAuth.getCurrentUser();
                                ref = database.getReferenceFromUrl("https://ecotourism-7983b.firebaseio.com/").child(currentUser.getUid());
                                ref.setValue(newProfile.getHashMap());
                                ref.child("Leased Places");
                                ref.child("BookedPlaces");
                                ref.child("BookmarkedPlaces");

                                Intent goHome = new Intent(getApplicationContext(), Home.class);
                                startActivity(goHome);

                            }else{
                                FirebaseAuthException e = (FirebaseAuthException )task.getException();
                                System.out.println("NOt worked" + e);
                            }
                        }
                    });
            }
        });

    }
}
