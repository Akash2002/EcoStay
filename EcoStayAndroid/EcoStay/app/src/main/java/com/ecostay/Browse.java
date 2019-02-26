package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.util.Log;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;

public class Browse extends AppCompatActivity {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;

    ArrayList<String> mLeaseNames = new ArrayList<>();
    ArrayList<String> mImageNames = new ArrayList<>();
    ArrayList<String> mUserID = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_browse);

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
        RecyclerViewAdapter adapter = new RecyclerViewAdapter(mLeaseNames, mImageNames, mUserID, this);
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

    }
}
