package com.ecostay;

import android.app.AppComponentFactory;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.RatingBar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;
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

    BottomNavigationView bottomNavigationView;

    private BottomNavigationView.OnNavigationItemSelectedListener onNavigationItemSelectedListener =
            new BottomNavigationView.OnNavigationItemSelectedListener() {
                @Override
                public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                    Intent nextScreen;

                    switch(item.getItemId()){
                        case R.id.navigation_search:
                            nextScreen = new Intent(getApplicationContext(), Home.class);
                            startActivity(nextScreen);
                            return true;
                        case R.id.navigation_browse:
                            nextScreen = new Intent(getApplicationContext(), Browse.class);
                            startActivity(nextScreen);
                            return true;
                        case R.id.navigation_createListing:
                            nextScreen = new Intent(getApplicationContext(), ViewListings.class);
                            startActivity(nextScreen);
                            return true;
                        case R.id.navigation_profile:
                            nextScreen = new Intent(getApplicationContext(), ViewProfile.class);
                            startActivity(nextScreen);
                            return true;
                    }

                    return false;
                }
            };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_browse_listing_info);

        bottomNavigationView = findViewById(R.id.btmNav);
        bottomNavigationView.setOnNavigationItemSelectedListener(onNavigationItemSelectedListener);

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
                address.setText(map.get(keys.getAddress()).toString());
                description.setText(map.get(keys.getDescription()).toString());
                price.setText(map.get(keys.getPrice()).toString());
                rate.setRating(Float.parseFloat(map.get(keys.getRating()).toString()));
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

        bookmark.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ref = database.getReference(getIntent().getExtras().get("User").toString() + "/BookmarkedPlaces");
                ref.child(name.getText().toString()).setValue("0");
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
                        float temp = Float.parseFloat(map.get("Rating").toString()) * Float.parseFloat(map.get("NumRated").toString());
                        temp += rate.getRating();
                        temp /= (Float.parseFloat(map.get("NumRated").toString()) + 1);
                        DatabaseReference ref2 = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("Listing Path") + "/Rating");
                        ref2.setValue(temp);
                        ref2 = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("Listing Path") + "/NumRated");
                        ref2.setValue(Float.parseFloat(map.get("NumRated").toString()) + 1);
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError databaseError) {

                    }
                });
            }
        });
    }
}
