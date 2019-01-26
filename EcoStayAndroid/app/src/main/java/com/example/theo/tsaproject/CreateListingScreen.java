package com.example.theo.tsaproject;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;

public class CreateListingScreen extends AppCompatActivity {

    TextView listName, address, price, descript, houseType;
    Spinner baths, beds;
    Button submitButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_listing_screen);

        listName = findViewById(R.id.ListingNameText);
        address = findViewById(R.id.AddressText);
        price = findViewById(R.id.PriceText);
        descript = findViewById(R.id.DescriptionText);
        houseType = findViewById(R.id.HouseTypeText);
        baths = findViewById(R.id.BathBox);
        beds = findViewById(R.id.BedsBox);
        submitButton = findViewById(R.id.submitListingButton);

        submitButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               Listing tempListing = new Listing(listName.getText().toString(), descript.getText().toString(), houseType.getText().toString(), address.getText().toString(), price.getText().toString(), (int) beds.getSelectedItem(), (int) baths.getSelectedItem());
                //to import into firebase
            }
        });
    }
}
