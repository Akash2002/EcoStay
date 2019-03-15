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

import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Locale;

public class CurrentBooking extends Fragment {

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
        View view = inflater.inflate(R.layout.tab_current_booking, container, false);

        return view;
    }

    @Override
    public void onStart() {
        super.onStart();

        initListItems();
    }

    public void initListItems(){

        mLeaseNames = new ArrayList<>();
        mImageNames = new ArrayList<>();
        mUserID = new ArrayList<>();
        mPrice = new ArrayList<>();
        mRating = new ArrayList<>();

        ref = database.getReference(user.getUid() + "/BookedPlaces");
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy", Locale.US);
                java.util.Calendar currentDate = Calendar.getInstance();
                for(DataSnapshot places : dataSnapshot.getChildren()){
                    String endDate = places.child("ToWhen").getValue(String.class);
                    String startDate = places.child("FromWhen").getValue(String.class);
                    if(format.format(format.parse(startDate, new ParsePosition(0))).compareTo(format.format(currentDate.getTime())) < 0 && format.format(format.parse(endDate, new ParsePosition(0))).compareTo(format.format(currentDate.getTime())) > 0){
                        mLeaseNames.add(places.getKey());
                    }
                }
                findListings();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });
    }

    private void initRecyclerView(){
        if(mImageNames.size() > 0) {
            defaultMessage = this.getView().findViewById(R.id.txtDefaultCurrent);
            //defaultMessage.setVisibility(View.INVISIBLE);
            Log.d("current", "rnn" + mImageNames.size());
            RecyclerView recyclerView = this.getView().findViewById(R.id.rvCurrentBooking);
            RecyclerViewAdapter adapter = new RecyclerViewAdapter(mLeaseNames, mImageNames, mUserID, mPrice, mRating, this.getContext());
            recyclerView.setAdapter(adapter);
            recyclerView.setLayoutManager(new LinearLayoutManager(this.getContext()));
        }
    }

    private void findListings(){
        DatabaseReference ref2 = database.getReferenceFromUrl("https://ecotourism-7983b.firebaseio.com/");
        ref2.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                for(DataSnapshot child : dataSnapshot.getChildren()){
                    for(DataSnapshot places2 : child.child("Leased Places").getChildren()){
                        for(String s : mLeaseNames){
                            Log.d("past", "looking: " + s + " " + places2.getKey());
                            if(s.equals(places2.getKey())) {
                                Log.d("past", "foudn");
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
}
