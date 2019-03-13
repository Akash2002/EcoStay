package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.HashMap;

public class Browse extends AppCompatActivity {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;

    ArrayList<String> mLeaseNames = new ArrayList<>();
    ArrayList<String> mImageNames = new ArrayList<>();
    ArrayList<String> mUserID = new ArrayList<>();
    ArrayList<String> mPrice = new ArrayList<>();
    ArrayList<String> mRating = new ArrayList<>();

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
        setContentView(R.layout.activity_browse);

        bottomNavigationView = findViewById(R.id.btmNav);
        bottomNavigationView.setOnNavigationItemSelectedListener(onNavigationItemSelectedListener);

        initImageBitmaps();
    }

    private void initImageBitmaps(){
        //https://i.redd.it/dlv4k8oq31h21.jpg

        ref = database.getReference();
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                for(DataSnapshot data : dataSnapshot.getChildren()){
                    if(data.hasChild("Leased Places")){
                        DataSnapshot places = data.child("Leased Places");
                        for(DataSnapshot child : places.getChildren()){
                            mLeaseNames.add(child.getKey());
                            mUserID.add(data.getKey());
                            mImageNames.add("https://i.redd.it/dlv4k8oq31h21.jpg");
                            mPrice.add(child.child("Price").getValue().toString());
                            mRating.add(child.child("Rating").getValue().toString());
                            Log.d("Browse", "User: " + data.getKey());
                        }
                    }
                }
                initRecyclerView();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });
    }

    private void initRecyclerView(){
        RecyclerView recyclerView = findViewById(R.id.rvBrowse);
        RecyclerViewAdapter adapter = new RecyclerViewAdapter(mLeaseNames, mImageNames, mUserID, mPrice, mRating, this);
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

    }
}
