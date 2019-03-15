package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;

import com.google.android.material.bottomnavigation.BottomNavigationView;

public class Controller extends AppCompatActivity {

    BottomNavigationView bottomNavigationView;

    Fragment goToFragment = null;

    private BottomNavigationView.OnNavigationItemSelectedListener onNavigationItemSelectedListener =
            new BottomNavigationView.OnNavigationItemSelectedListener() {
                @Override
                public boolean onNavigationItemSelected(@NonNull MenuItem item) {

                    switch(item.getItemId()){
                        case R.id.navigation_search:
                            goToFragment = new Home();
                            break;
                        case R.id.navigation_browse:
                            goToFragment = new Browse();
                            break;
                        case R.id.navigation_createListing:
                            goToFragment = new ViewListings();
                            break;
                        case R.id.navigation_profile:
                            goToFragment = new ViewProfile();
                            break;
                    }

                    getFragmentManager().beginTransaction().replace(R.id.clControl, goToFragment).commit();
                    return true;
                }
            };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_controller);

        bottomNavigationView = findViewById(R.id.btmNav);
        bottomNavigationView.setOnNavigationItemSelectedListener(onNavigationItemSelectedListener);

        if(getIntent().hasExtra("Fragment")) {
            if (getIntent().getExtras().get("Fragment").equals("Browse")) {
                goToFragment = new Browse();
            } else if (getIntent().getExtras().get("Fragment").equals("Listings")) {
                goToFragment = new ViewListings();
            }
        }else{
            goToFragment = new Home();
        }
        getFragmentManager().beginTransaction().replace(R.id.clControl, goToFragment).commit();
    }
}
