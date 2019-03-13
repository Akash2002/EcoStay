package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.VoiceInteractor;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;

public class ViewListings extends AppCompatActivity {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;
    FirebaseAuth mAuth = FirebaseAuth.getInstance();
    FirebaseUser user = mAuth.getCurrentUser();

    FloatingActionButton button;
    TextInputLayout defaultMessage;

    private ArrayList<String> mNames = new ArrayList<>();
    private ArrayList<String> mImages = new ArrayList<>();
    private ArrayList<String> mUserID = new ArrayList<>();
    private ArrayList<String> mPrice = new ArrayList<>();
    private ArrayList<String> mRating = new ArrayList<>();

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
        setContentView(R.layout.activity_view_listings);

        bottomNavigationView = findViewById(R.id.btmNav);
        bottomNavigationView.setOnNavigationItemSelectedListener(onNavigationItemSelectedListener);

        button = findViewById(R.id.btnNewListing);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent goCreateListing = new Intent(getApplicationContext(), CreateListing.class);
                startActivity(goCreateListing);
            }
        });

        initImageBitmaps();
    }

    private void initImageBitmaps(){
        //https://i.redd.it/dlv4k8oq31h21.jpg
        ref = database.getReference(user.getUid() + "/Leased Places");
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                for(DataSnapshot child: dataSnapshot.getChildren()){
                    mNames.add(child.getKey());
                    mUserID.add(user.getUid());
                    mImages.add("https://i.redd.it/dlv4k8oq31h21.jpg");
                    mPrice.add(child.child("Price").getValue().toString());
                    mRating.add(child.child("Rating").getValue().toString());
                }
                initRecyclerView();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });
    }

    private void initRecyclerView(){
        if(mNames.size() > 0) {
            defaultMessage = findViewById(R.id.txtDefaultListing);
            defaultMessage.setVisibility(View.INVISIBLE);
            RecyclerView recyclerView = findViewById(R.id.rvViewListings);
            RecyclerViewAdapterMyListings adapter = new RecyclerViewAdapterMyListings(mNames, mImages, mUserID, mPrice, mRating, this);
            recyclerView.setAdapter(adapter);
            recyclerView.setLayoutManager(new LinearLayoutManager(this));
        }
    }


}
