package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class CreateListing extends AppCompatActivity {

    FirebaseAuth mAuth;
    FirebaseDatabase database;
    DatabaseReference ref;
    FirebaseUser currentUser;
    TextInputEditText name, description, address, type, price, bed, bath;
    Button createListing;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_listing);

        mAuth = FirebaseAuth.getInstance();
        currentUser = mAuth.getCurrentUser();
        database = FirebaseDatabase.getInstance();
        ref = database.getReference(currentUser.getUid() + "/Listed Places");

        createListing = findViewById(R.id.btnCreateListing);
        createListing.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                name = findViewById(R.id.edttxtListName);
                description = findViewById(R.id.edttxtDescription);
                address = findViewById(R.id.edttxtAddress);
                type = findViewById(R.id.edttxtType);
                price = findViewById(R.id.edttxtPrice);
                bed = findViewById(R.id.edttxtBed);
                bath = findViewById(R.id.edttxtBath);

                Listing newListing = new Listing(name.getText().toString(), description.getText().toString(), address.getText().toString(),type.getText().toString(),
                        Double.parseDouble(price.getText().toString()), Integer.parseInt(bed.getText().toString()), Integer.parseInt(bath.getText().toString()));

                ref.child(name.getText().toString());
                ref = database.getReference(currentUser.getUid() + "/Leased Places/" + name.getText().toString());
                ref.setValue(newListing.getHashMap());

                Intent goHome = new Intent(getApplicationContext(), Home.class);
                startActivity(goHome);
            }
        });
    }
}
