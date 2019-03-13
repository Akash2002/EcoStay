package com.ecostay;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import java.util.ArrayList;

public class SectionViewAdapter extends FragmentPagerAdapter {

    private ArrayList<Fragment> mFragmentList = new ArrayList<>();
    private ArrayList<String> mFragmentName = new ArrayList();

    public SectionViewAdapter(@NonNull FragmentManager fm) {
        super(fm);
    }

    public void addFragment(Fragment frag, String name){
        mFragmentList.add(frag);
        mFragmentName.add(name);
    }

    @NonNull
    @Override
    public Fragment getItem(int position) {
        return mFragmentList.get(position);
    }

    @Override
    public int getCount() {
        return mFragmentList.size();
    }

    @Nullable
    @Override
    public CharSequence getPageTitle(int position) {
        return mFragmentName.get(position);
    }

    private void clear(){
        mFragmentList = new ArrayList<>();
        mFragmentName = new ArrayList<>();
    }


}
