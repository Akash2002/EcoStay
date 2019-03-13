package com.ecostay;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;

public class ViewBookmarked extends Fragment {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;

    FirebaseAuth mAuth = FirebaseAuth.getInstance();
    FirebaseUser user = mAuth.getCurrentUser();

    TextInputLayout defaultMessage;

    ArrayList<String> mLeaseNames = new ArrayList<>();
    ArrayList<String> mImageNames = new ArrayList<>();
    ArrayList<String> mUserID = new ArrayList<>();
    ArrayList<String> mPrice = new ArrayList<>();
    ArrayList<String> mRating = new ArrayList<>();

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState){
        View view = inflater.inflate(R.layout.tab_bookmarked_places, container, false);

        return view;
    }

    @Override
    public void onStart() {
        super.onStart();

        initBookmarkedPlaces();
    }

    public void initBookmarkedPlaces(){

        mLeaseNames = new ArrayList<>();
        mImageNames = new ArrayList<>();
        mUserID = new ArrayList<>();
        mPrice = new ArrayList<>();
        mRating = new ArrayList<>();

        ref = database.getReference(user.getUid() + "/BookmarkedPlaces");
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                for(DataSnapshot child : dataSnapshot.getChildren()){
                    mLeaseNames.add(child.getKey());
                }
                findListings();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });

    }

    private void findListings(){
        DatabaseReference ref2 = database.getReferenceFromUrl("https://ecotourism-7983b.firebaseio.com/");
        ref2.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                for(DataSnapshot child : dataSnapshot.getChildren()){
                    for(DataSnapshot places2 : child.child("Leased Places").getChildren()){
                        for(String s : mLeaseNames){
                            Log.d("bookmarked", "looking: " + s + " " + places2.getKey());
                            if(s.equals(places2.getKey())) {
                                mImageNames.add("https://i.redd.it/dlv4k8oq31h21.jpg");
                                mUserID.add(child.getKey());
                                mPrice.add(places2.child("Price").getValue().toString());
                                mRating.add(places2.child("Rating").getValue().toString());
                            }
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

    public void initRecyclerView(){
        if(mLeaseNames.size() > 0) {
            defaultMessage = this.getView().findViewById(R.id.txtDefaultBookmark);
            defaultMessage.setVisibility(View.INVISIBLE);
            RecyclerView recyclerView = this.getView().findViewById(R.id.rvBookmark);
            RecyclerViewAdapter adapter = new RecyclerViewAdapter(mLeaseNames, mImageNames, mUserID, mPrice, mRating, this.getContext());
            recyclerView.setAdapter(adapter);
            recyclerView.setLayoutManager(new LinearLayoutManager(this.getContext()));
        }
    }
}
