package com.ecostay;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;
import androidx.viewpager.widget.ViewPager;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

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

import javax.security.auth.login.LoginException;

public class ViewProfile extends Fragment {

    FirebaseAuth mAuth;
    FirebaseUser currentUser;
    FirebaseDatabase database;
    DatabaseReference ref;
    Button logoutButton;

    TextInputEditText name, email, phone, password;

    View v;

    private ViewPager mViewPager;
    private FragmentActivity myContext;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.activity_view_profile, container, false);

        name = v.findViewById(R.id.edttxtNameDisplay);
        email = v.findViewById(R.id.edttxtEmailDisplay);
        phone = v.findViewById(R.id.edttxtPhoneDisplay);
        logoutButton = v.findViewById(R.id.logoutButton);

        mAuth = FirebaseAuth.getInstance();
        currentUser = mAuth.getCurrentUser();
        database = FirebaseDatabase.getInstance();

        mViewPager = v.findViewById(R.id.viewpagerProfile);
        setUpViewPager(mViewPager);

        logoutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FirebaseAuth.getInstance().signOut();
                Intent intent = new Intent(v.getContext(), Login.class);
                startActivity(intent);
            }
        });

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

        return v;
    }

    private void setUpViewPager(ViewPager viewPager){
        SectionViewAdapter adapter = new SectionViewAdapter(myContext.getSupportFragmentManager());
        adapter.addFragment(new CurrentBooking(), "Current Booking");
        adapter.addFragment(new PastBookings(), "Past Bookings");
        adapter.addFragment(new ViewBookedListings(), "Upcoming Bookings");
        adapter.addFragment(new ViewBookmarked(), "Book marked");
        viewPager.setAdapter(adapter);
    }

    @Override
    public void onAttach(Activity activity){
        myContext = (FragmentActivity) activity;
        super.onAttach(myContext);
    }
}
