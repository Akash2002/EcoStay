package com.ecostay;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.google.android.material.textfield.TextInputEditText;

public class CreateListing extends AppCompatActivity {

    TextInputEditText name, description, address, type, price, bed, bath;
    Button createListing;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_listing);

        createListing = findViewById(R.id.btnCreateListing);
        createListing.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                name = findViewById(R.id.txtListName);
                description = findViewById(R.id.txtDescription);
                address = findViewById(R.id.txtAddress);
                type = findViewById(R.id.txtType);
                price = findViewById(R.id.txtPrice);
                bed = findViewById(R.id.txtBed);
                bath = findViewById(R.id.txtBath);

                Listing newListing = new Listing(name.getText().toString(), description.getText().toString(), address.getText().toString(),type.getText().toString(),
                        Double.parseDouble(price.getText().toString()), Integer.parseInt(bed.getText().toString()), Integer.parseInt(bath.getText().toString()));

                Intent goHome = new Intent(getApplicationContext(), Home.class);
                startActivity(goHome);
            }
        });
    }
}
