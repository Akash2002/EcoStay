package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.CalendarView;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.text.DateFormat;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class Booking extends AppCompatActivity {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;
    FirebaseAuth mAuth = FirebaseAuth.getInstance();
    FirebaseUser user = mAuth.getCurrentUser();

    MaterialButton submit, startDate, endDate;

    CalendarView cal;
    Calendar start = new com.ecostay.Calendar();
    Calendar end = new com.ecostay.Calendar();
    int control = 1;

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
                            nextScreen = new Intent(getApplicationContext(), Browse.class);
                            startActivity(nextScreen);
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
        setContentView(R.layout.activity_booking);

        submit = findViewById(R.id.btnConfirmBook);

        bottomNavigationView = findViewById(R.id.btmNav);
        bottomNavigationView.setOnNavigationItemSelectedListener(onNavigationItemSelectedListener);

        startDate = findViewById(R.id.btnStartDate);
        endDate = findViewById(R.id.btnEndDate);

        startDate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                control = 1;
            }
        });

        endDate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                control = 0;
            }
        });

        cal = findViewById(R.id.calendarView);

        cal.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
            @Override
            public void onSelectedDayChange(@NonNull CalendarView view, int year, int month, int dayOfMonth) {
                Log.d("Booking", "Switch: " + control);

                switch(control){
                    case 0:
                        end.set(year, month, dayOfMonth);
                        String message = "End Date: " + month + "/" + dayOfMonth + "/" + year;
                        endDate.setText(message);
                        break;
                    case 1:
                        start.set(year, month, dayOfMonth);
                        String message1 = "Start Date: " + month + "/" + dayOfMonth + "/" + year;
                        startDate.setText(message1);
                        break;
                    default:
                        break;
                }
            }
        });

        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SimpleDateFormat form = new SimpleDateFormat("MM/dd/yyyy", Locale.US);

                ref = database.getReference(user.getUid() + "/BookedPlaces");
                ref.child(getIntent().getExtras().get("List Name").toString());
                ref = database.getReference(user.getUid() + "/BookedPlaces/" + getIntent().getExtras().get("List Name").toString());
                ref.child("FromWhen").setValue(form.format(form.parse(start.toString(), new ParsePosition(0))));
                ref.child("ToWhen").setValue(form.format(form.parse(end.toString(), new ParsePosition(0))));

                ref = database.getReference(getIntent().getExtras().get("User") + "/" + getIntent().getExtras().get("List Name") + "/Booked Dates");
                ref.child(user.getUid());
                ref = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("List Name") + "/Booked Dates/" + user.getUid());
                ref.child("FromWhen").setValue(form.format(form.parse(start.toString(), new ParsePosition(0))));
                ref.child("ToWhen").setValue(form.format(form.parse(end.toString(), new ParsePosition(0))));

                Intent goBrowse = new Intent(getApplicationContext(), Browse.class);
                startActivity(goBrowse);
            }
        });
    }
}
