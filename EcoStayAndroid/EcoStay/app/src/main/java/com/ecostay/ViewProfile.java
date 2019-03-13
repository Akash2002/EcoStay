package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import org.w3c.dom.Text;

import java.util.HashMap;

public class ViewProfile extends AppCompatActivity {

    FirebaseAuth mAuth;
    FirebaseUser currentUser;
    FirebaseDatabase database;
    DatabaseReference ref;

    TextInputEditText name, email, phone, password;

    BottomNavigationView bottomNavigationView;

    private ViewPager mViewPager;

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
                            return true;
                    }

                    return false;
                }
            };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_profile);

        bottomNavigationView = findViewById(R.id.btmNav);
        bottomNavigationView.setOnNavigationItemSelectedListener(onNavigationItemSelectedListener);

        name = findViewById(R.id.edttxtNameDisplay);
        email = findViewById(R.id.edttxtEmailDisplay);
        phone = findViewById(R.id.edttxtPhoneDisplay);

        mAuth = FirebaseAuth.getInstance();
        currentUser = mAuth.getCurrentUser();
        database = FirebaseDatabase.getInstance();

        mViewPager = findViewById(R.id.viewpagerProfile);
        setUpViewPager(mViewPager);

        ref = database.getReference(currentUser.getUid());
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                AccountKeys keys = new AccountKeys();

                HashMap map = (HashMap) dataSnapshot.getValue();
                name.setText(map.get(keys.getName()).toString());
                email.setText(map.get(keys.getEmail()).toString());
                phone.setText(map.get(keys.getPhone()).toString());
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });
    }

    private void setUpViewPager(ViewPager viewPager){
        SectionViewAdapter adapter = new SectionViewAdapter(getSupportFragmentManager());
        adapter.addFragment(new CurrentBooking(), "Current Booking");
        adapter.addFragment(new PastBookings(), "Past Bookings");
        adapter.addFragment(new ViewBookedListings(), "Upcoming Bookings");
        adapter.addFragment(new ViewBookmarked(), "Book marked");
        viewPager.setAdapter(adapter);
    }
}
