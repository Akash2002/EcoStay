package com.ecostay;

import android.app.AppComponentFactory;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RatingBar;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;

public class BrowseListingInfo extends AppCompatActivity {
    TextInputEditText name, address, description, price;
    MaterialButton booking, bookmark;

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;
    RatingBar rate;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_browse_listing_info);

        name = findViewById(R.id.edttxtListingName);
        address = findViewById(R.id.edttxtListingAddress);
        description = findViewById(R.id.edttxtListingDescription);
        price = findViewById(R.id.edttxtListingPrice);
        booking = findViewById(R.id.btnBook);
        bookmark = findViewById(R.id.btnBookmark);
        rate = findViewById(R.id.ratingBar);

        ref = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("Listing Path"));
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                LeasedKeys keys = new LeasedKeys();
                HashMap map = (HashMap) dataSnapshot.getValue();
                name.setText(dataSnapshot.getKey());
                address.setText(("Address: " + map.get(keys.getAddress()).toString()));
                description.setText(map.get(keys.getDescription()).toString());
                price.setText(("$" + map.get(keys.getPrice()).toString() + "/night"));
                rate.setRating(Float.parseFloat(map.get(keys.getRating()).toString()));
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });

        booking.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent goToBooking = new Intent(v.getContext(), Booking.class);
                goToBooking.putExtra("List Name", name.getText().toString());
                goToBooking.putExtra("User", getIntent().getExtras().get("User").toString());
                startActivity(goToBooking);
            }
        });

        bookmark.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ref = database.getReference(getIntent().getExtras().get("User").toString() + "/BookmarkedPlaces");
                ref.child(name.getText().toString()).setValue("0");
                Toast.makeText(getApplicationContext(), "Bookmarked", Toast.LENGTH_SHORT).show();
            }
        });

        rate.setOnRatingBarChangeListener(new RatingBar.OnRatingBarChangeListener() {
            @Override
            public void onRatingChanged(RatingBar ratingBar, float rating, boolean fromUser) {
                ref = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("Listing Path"));
                ref.addListenerForSingleValueEvent(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                        HashMap map = (HashMap) dataSnapshot.getValue();
                        float temp = Float.parseFloat(map.get("Rating").toString()) * Float.parseFloat(map.get("RatingNum").toString());
                        temp += rate.getRating();
                        temp /= (Float.parseFloat(map.get("RatingNum").toString()) + 1);
                        DatabaseReference ref2 = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("Listing Path") + "/Rating");
                        ref2.setValue(Float.toString(temp));
                        ref2 = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("Listing Path") + "/NumRated");
                        ref2.setValue(map.get("RatingNum").toString() + 1);
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError databaseError) {

                    }
                });
            }
        });
    }
}
