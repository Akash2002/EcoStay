package com.ecostay;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.util.AndroidRuntimeException;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.HashMap;

public class Home extends Fragment {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;

    View v;

    ArrayList<Listing> listings = new ArrayList<>();

    ArrayList mLeaseNames = new ArrayList();
    ArrayList mImageNames = new ArrayList();
    ArrayList mUserID = new ArrayList();
    ArrayList mPrice = new ArrayList();
    ArrayList mRating = new ArrayList();

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.activity_home, container, false);

        initLists();
        return v;
    }

    private void initLists(){

        ref = database.getReference();
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                for(DataSnapshot data : dataSnapshot.getChildren()){
                    if(data.hasChild("Leased Places")){
                        DataSnapshot places = data.child("Leased Places");
                        for(DataSnapshot child : places.getChildren()){
                            HashMap map = (HashMap) child.getValue();
                            listings.add(new Listing(child.getKey(), map.get("Price").toString(), map.get("Rating").toString(), data.getKey().toString()));
                        }
                    }
                }
                sortLists();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });

    }

    private void sortLists(){
        for(int i = 0; i < listings.size(); i++){
            int index = i;
            double max = Double.parseDouble(listings.get(i).getHashMap().get("Rating").toString());
            for(int j = i + 1; j < listings.size(); j++) {
                if (max < Double.parseDouble(listings.get(j).getHashMap().get("Rating").toString())){
                    max = Double.parseDouble(listings.get(j).getHashMap().get("Rating").toString());
                    index = j;
                }
            }

            Listing temp = new Listing();
            temp = listings.get(i);
            listings.set(i, listings.get(index));
            listings.set(index, temp);
        }

        Log.d("Home", Integer.toString(listings.size()));
        for(Listing l : listings){
            mLeaseNames.add(l.getHashMap().get("Name"));
            mImageNames.add("https://i.redd.it/dlv4k8oq31h21.jpg");
            mUserID.add(l.getHashMap().get("Uid"));
            mPrice.add(l.getHashMap().get("Price"));
            mRating.add(l.getHashMap().get("Rating"));
        }
        initRecyclerView();
    }

    private void initRecyclerView(){
        RecyclerView recyclerView = v.findViewById(R.id.rvHome);
        RecyclerViewAdapter adapter = new RecyclerViewAdapter(mLeaseNames, mImageNames, mUserID, mPrice, mRating, v.getContext());
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(v.getContext(), LinearLayoutManager.HORIZONTAL, false));
    }
}
