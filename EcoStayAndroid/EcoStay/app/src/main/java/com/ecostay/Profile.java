package com.ecostay;

import java.util.HashMap;

public class Profile {

    private HashMap hashMap;

    public Profile(String name, String email, String phoneNumber, String birthday, String password) {

        AccountKeys keys = new AccountKeys();

        hashMap = new HashMap();
        hashMap.put(keys.getName(), name);
        hashMap.put(keys.getEmail(), email);
        hashMap.put(keys.getPhone(), phoneNumber);
        hashMap.put(keys.getDOB(), birthday);
    }

    public HashMap getHashMap(){
        return hashMap;
    }
}
