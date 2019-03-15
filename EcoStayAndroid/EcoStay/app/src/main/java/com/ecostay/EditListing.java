package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;

public class EditListing extends AppCompatActivity {

    FirebaseAuth mAuth = FirebaseAuth.getInstance();
    FirebaseUser user = mAuth.getCurrentUser();

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;

    MaterialButton saveChanges, delete;
    TextInputEditText name, address, description, price;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_listing);

        saveChanges = findViewById(R.id.btnSaveChanges);

        saveChanges.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ref = database.getReference(user.getUid() + "/Leased Places/" + getIntent().getExtras().get("Listing Path") + "/Name");
                ref.setValue(name.getText().toString());

                ref = database.getReference(user.getUid() + "/Leased Places/" + getIntent().getExtras().get("Listing Path") + "/Description");
                ref.setValue(description.getText().toString());

                ref = database.getReference(user.getUid() + "/Leased Places/" + getIntent().getExtras().get("Listing Path") + "/Address");
                ref.setValue(address.getText().toString());

                ref = database.getReference(user.getUid() + "/Leased Places/" + getIntent().getExtras().get("Listing Path") + "/Price");
                ref.setValue(price.getText().toString());

                Intent goViewListings = new Intent(getApplicationContext(), ViewListings.class);
                startActivity(goViewListings);
            }
        });

        name = findViewById(R.id.edttxtListingName);
        address = findViewById(R.id.edttxtListingAddress);
        description = findViewById(R.id.edttxtListingDescription);
        price = findViewById(R.id.edttxtListingPrice);
        delete = findViewById(R.id.btnDeleteListing);

        ref = database.getReference(user.getUid() + "/Leased Places/" + getIntent().getExtras().get("Listing Path"));
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                LeasedKeys keys = new LeasedKeys();
                HashMap map = (HashMap) dataSnapshot.getValue();
                name.setText(dataSnapshot.getKey());
                address.setText(map.get(keys.getAddress()).toString());
                description.setText(map.get(keys.getDescription()).toString());
                price.setText(map.get(keys.getPrice()).toString());
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });

        delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ref.removeValue();
            }
        });
    }
}
