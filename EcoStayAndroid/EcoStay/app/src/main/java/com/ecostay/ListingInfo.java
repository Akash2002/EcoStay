package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

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

public class ListingInfo extends AppCompatActivity {

    TextInputEditText name, address, description, price;
    MaterialButton booking;

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;
    FirebaseAuth mAuth = FirebaseAuth.getInstance();
    FirebaseUser user = mAuth.getCurrentUser();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_listing_info);

        name = findViewById(R.id.edttxtListingName);
        address = findViewById(R.id.edttxtListingAddress);
        description = findViewById(R.id.edttxtListingDescription);
        price = findViewById(R.id.edttxtListingPrice);
        booking = findViewById(R.id.btnBook);

        ref = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("Listing Path"));
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

        booking.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent goToBooking = new Intent(getApplicationContext(), Booking.class);
                goToBooking.putExtra("List Name", name.getText().toString());
                goToBooking.putExtra("User", getIntent().getExtras().get("User").toString());
                startActivity(goToBooking);
            }
        });
    }
}
