package com.ecostay;

import java.util.ArrayList;
import java.util.HashMap;

public class Listing {

    private HashMap hashMap;
    private HashMap amenitiesMap;
//    private String name;
//    private String description;
//    private String address; //to be replaced with google location class
//    private String typeOfHouse;
//    private String rating;
//    private String ratingNum;
//    private int bed;
//    private int bath;
//    private double price;
//    private ArrayList<String> reviews;

    public Listing(String name, String description, String address, String typeOfHouse, double price, int bed, int bath) {
        hashMap = new HashMap();
        amenitiesMap = new HashMap();
        LeasedKeys keys = new LeasedKeys();

        amenitiesMap.put(keys.getBed(), bed);
        amenitiesMap.put(keys.getBath(), bath);

        hashMap.put(keys.getName(), name);
        hashMap.put(keys.getDescription(), description);
        hashMap.put(keys.getAddress(), address);
        hashMap.put(keys.getPrice(), price);
        hashMap.put(keys.getAmenities(), amenitiesMap);
        hashMap.put(keys.getType(), typeOfHouse);
    }

    public HashMap getHashMap(){
        return hashMap;
    }
}
