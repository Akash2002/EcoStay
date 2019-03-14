package com.ecostay;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.InflateException;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

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
import java.util.zip.Inflater;

public class Browse extends android.app.Fragment {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;

    ArrayList<String> mLeaseNames = new ArrayList<>();
    ArrayList<String> mImageNames = new ArrayList<>();
    ArrayList<String> mUserID = new ArrayList<>();
    ArrayList<String> mPrice = new ArrayList<>();
    ArrayList<String> mRating = new ArrayList<>();

    View v;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.activity_browse, container, false);

        initImageBitmaps();
        return v;
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
        RecyclerView recyclerView = v.findViewById(R.id.rvBrowse);
        RecyclerViewAdapter adapter = new RecyclerViewAdapter(mLeaseNames, mImageNames, mUserID, mPrice, mRating, v.getContext());
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(v.getContext()));

    }
}
