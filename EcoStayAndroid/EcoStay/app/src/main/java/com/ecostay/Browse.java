package com.ecostay;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SearchView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.HashMap;

public class Browse extends Fragment {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;
    View v;

    androidx.appcompat.widget.SearchView search;

    String find;

    ArrayList<String> mLeaseNames = new ArrayList<>();
    ArrayList<String> mImageNames = new ArrayList<>();
    ArrayList<String> mUserID = new ArrayList<>();
    ArrayList<String> mPrice = new ArrayList<>();
    ArrayList<String> mRating = new ArrayList<>();

    RecyclerViewAdapter adapter;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.activity_browse, container, false);

        search = v.findViewById(R.id.sbBrowse);
        search.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                if(!query.isEmpty()){
                    find = search.getQuery().toString();
                    findLists(find);
                }else{
                    clearArray();
                    initImageBitmaps();
                }
                return true;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                if(!newText.isEmpty()){
                    find = search.getQuery().toString();
                    findLists(find);
                }else{
                    clearArray();
                    initImageBitmaps();
                }
                return true;
            }
        });

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
        adapter = new RecyclerViewAdapter(mLeaseNames, mImageNames, mUserID, mPrice, mRating, v.getContext());
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(v.getContext()));
    }

    private void refreshRV(){
        adapter.addItems(mLeaseNames, mImageNames, mUserID, mPrice, mRating, v.getContext());
        adapter.notifyDataSetChanged();

    }

    public void findLists(final String s){

        ref = database.getReference();
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                clearArray();
                for(DataSnapshot user : dataSnapshot.getChildren()){
                    for(DataSnapshot places: user.child("Leased Places").getChildren()){
                        if(places.getKey().toLowerCase().contains(s.toLowerCase())){
                            mLeaseNames.add(places.getKey());
                            mImageNames.add("https://i.redd.it/dlv4k8oq31h21.jpg");
                            mPrice.add(((HashMap) places.getValue()).get("Price").toString());
                            mRating.add(((HashMap) places.getValue()).get("Rating").toString());
                            mUserID.add(user.getKey());

                        }
                    }
                }
                Log.d("Browse", mLeaseNames.toString());
                refreshRV();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });
    }

    public void clearArray(){
        mImageNames.clear();
        mLeaseNames.clear();
        mPrice.clear();
        mRating.clear();
        mUserID.clear();
    }
}
