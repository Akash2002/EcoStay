package com.ecostay;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.CalendarView;

import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.Calendar;

public class Booking extends AppCompatActivity {

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference ref;
    FirebaseAuth mAuth = FirebaseAuth.getInstance();
    FirebaseUser user = mAuth.getCurrentUser();

    TextInputEditText startDate, endDate;
    TextInputLayout startDateLayout, endDateLayout;

    MaterialButton submit;

    CalendarView cal;
    Calendar start = new com.ecostay.Calendar();
    Calendar end = new com.ecostay.Calendar();
    int control = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_booking);

        submit = findViewById(R.id.btnConfirmBook);

        startDateLayout = findViewById(R.id.txtStartDate);
        endDateLayout = findViewById(R.id.txtEndDate);

        startDate = findViewById(R.id.edttxtStartDate);
        endDate = findViewById(R.id.edttxtEndDate);

        startDateLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                control = 1;
            }
        });

        startDate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                control = 1;
            }
        });

        endDateLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                control = 0;
                Log.d("Booking", "CLicked: " + control);
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
                ref = database.getReference(user.getUid() + "/Booked");
                ref.child(getIntent().getExtras().get("List Name").toString());
                ref = database.getReference(user.getUid() + "/Booked/" + getIntent().getExtras().get("List Name").toString());
                ref.child("FromWhen").setValue(start.toString());
                ref.child("ToWhen").setValue(end.toString());

                ref = database.getReference(getIntent().getExtras().get("User") + "/" + getIntent().getExtras().get("List Name") + "/Booked Dates");
                ref.child(user.getUid());
                ref = database.getReference(getIntent().getExtras().get("User") + "/Leased Places/" + getIntent().getExtras().get("List Name") + "/Booked Dates/" + user.getUid());
                ref.child("FromWhen").setValue(start.toString());
                ref.child("ToWhen").setValue(end.toString());
            }
        });
    }
}
