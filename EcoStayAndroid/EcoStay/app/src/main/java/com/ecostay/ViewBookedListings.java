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

public class ViewBookedListings extends Fragment {

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
        View view = inflater.inflate(R.layout.tab_booked_places, container, false);
        Log.d("PU", "inflate");

        return view;
    }

    @Override
    public void onStart() {
        super.onStart();

        initListItems();
    }

    public void initListItems(){

        mLeaseNames.clear();
        mImageNames.clear();
        mUserID.clear();
        mPrice.clear();
        mRating.clear();

        ref = database.getReference(user.getUid() + "/BookedPlaces");
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy", Locale.US);
                java.util.Calendar currentDate = Calendar.getInstance();
                for(DataSnapshot places : dataSnapshot.getChildren()){
                    String date = places.child("FromWhen").getValue(String.class);
                    if(format.format(format.parse(date, new ParsePosition(0))).compareTo(format.format(currentDate.getTime())) > 0){
                        mLeaseNames.add(places.getKey());
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });

        DatabaseReference ref2 = database.getReference();
        ref2.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                for(DataSnapshot child : dataSnapshot.getChildren()){
                    for(DataSnapshot places2 : child.child("Leased Places").getChildren()){
                        for(String s : mLeaseNames){
                            if(s.equals(places2.getKey())) {
                                Log.d("up", "foudn");
                                mImageNames.add("https://i.redd.it/dlv4k8oq31h21.jpg");
                                mUserID.add(child.getKey());
                                mPrice.add((places2.child("Price").getValue().toString()));
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

    private void initRecyclerView(){
        Log.d("UP", Integer.toString(mImageNames.size()));
        if(mImageNames.size() > 0) {
            defaultMessage = this.getView().findViewById(R.id.txtDefaultFutureBooking);
            defaultMessage.setVisibility(View.INVISIBLE);
            RecyclerView recyclerView = this.getView().findViewById(R.id.rvUpcomingBookings);
            RecyclerViewAdapter adapter = new RecyclerViewAdapter(mLeaseNames, mImageNames, mUserID, mPrice, mRating, this.getContext());
            Log.d("up", "rnn" + mImageNames.size());
            recyclerView.setAdapter(adapter);
            recyclerView.setLayoutManager(new LinearLayoutManager(this.getContext()));
        }
    }
}
