package com.example.theo.tsaproject;

public class Listing {

    private String listName;
    private String description;
    private String houseType;
    private String address;
    private double lat; //I think google has a location class in one of their apis
    private double lon;
    private double price;
    private int bed;
    private int bath;

    public Listing(String listName, String description, String houseType, String address, String price, int bed, int bath) {
        this.listName = listName;
        this.description = description;
        this.houseType = houseType;
        this.address = address;
        this.price = Double.parseDouble(price);
        this.bed = bed;
        this.bath = bath;
    }

    public String getListName() {
        return listName;
    }

    public void setListName(String listName) {
        this.listName = listName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getHouseType() {
        return houseType;
    }

    public void setHouseType(String houseType) {
        this.houseType = houseType;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    public double getLon() {
        return lon;
    }

    public void setLon(double lon) {
        this.lon = lon;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getBed() {
        return bed;
    }

    public void setBed(int bed) {
        this.bed = bed;
    }

    public int getBath() {
        return bath;
    }

    public void setBath(int bath) {
        this.bath = bath;
    }
}
