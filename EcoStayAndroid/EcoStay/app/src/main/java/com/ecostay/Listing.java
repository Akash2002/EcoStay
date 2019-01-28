package com.ecostay;

import java.util.ArrayList;

public class Listing {

    private String name;
    private String description;
    private String address; //to be replaced with google location class
    private String typeOfHouse;
    private int bed;
    private int bath;
    private double price;
    private ArrayList<String> reviews;

    public Listing(String name, String description, String address, String typeOfHouse, double price, int bed, int bath) {
        this.name = name;
        this.description = description;
        this.address = address;
        this.typeOfHouse = typeOfHouse;
        this.price = price;
        this.bed = bed;
        this.bath = bath;
    }
}
