package com.ecostay;

import android.app.FragmentManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.google.android.material.textfield.TextInputEditText;

import java.util.ArrayList;

public class RecyclerViewAdapter extends RecyclerView.Adapter<RecyclerViewAdapter.ViewHolder> {

    private ArrayList<String> mLeaseNames = new ArrayList<>();
    private ArrayList<String> mLeaseImage = new ArrayList<>();
    private ArrayList<String> mUserID = new ArrayList<>();
    private ArrayList<String> mPrice = new ArrayList<>();
    private ArrayList<String> mRating = new ArrayList<>();
    private Context mContext;

    public RecyclerViewAdapter(ArrayList<String> mLeaseNames, ArrayList<String> mLeaseImage, ArrayList<String> inUserID, ArrayList<String> inPrice, ArrayList<String> inRating, Context mContext) {
        this.mLeaseNames = mLeaseNames;
        this.mLeaseImage = mLeaseImage;
        this.mUserID = inUserID;
        this.mPrice = inPrice;
        this.mRating = inRating;
        this.mContext = mContext;
    }

    public void addItems(ArrayList<String> mLeaseNames, ArrayList<String> mLeaseImage, ArrayList<String> inUserID, ArrayList<String> inPrice, ArrayList<String> inRating, Context mContext) {
        this.mLeaseNames = mLeaseNames;
        this.mLeaseImage = mLeaseImage;
        this.mUserID = inUserID;
        this.mPrice = inPrice;
        this.mRating = inRating;
        this.mContext = mContext;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_listitem, parent, false);
        ViewHolder holder = new ViewHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {

        Glide.with(mContext)
                .asBitmap()
                .load(mLeaseImage.get(position))
                .into(holder.image);
        holder.editText.setText(mLeaseNames.get(position));
        String tempPrice = "$" + mPrice.get(position) + "/night";
        holder.priceText.setText(tempPrice);
        holder.rate.setRating(Float.parseFloat(mRating.get(position)));

        holder.parentLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent goToBrowseListingInfo = new Intent(mContext.getApplicationContext(), BrowseListingInfo.class);
                goToBrowseListingInfo.putExtra("Listing Path", mLeaseNames.get(position));
                goToBrowseListingInfo.putExtra("User", mUserID.get(position));
                mContext.startActivity(goToBrowseListingInfo);
            }
        });
    }

    public void clear(){
        mLeaseNames.clear();
        mLeaseImage.clear();
        mPrice.clear();
        mRating.clear();
        mUserID.clear();
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return mLeaseNames.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder{

        ImageView image;
        TextInputEditText editText, amenitiesText, priceText;
        RatingBar rate;
        RelativeLayout parentLayout;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            image = itemView.findViewById(R.id.image);
            editText = itemView.findViewById(R.id.edttxtLeaseName);
            amenitiesText = itemView.findViewById(R.id.edttxtListAmenities);
            priceText = itemView.findViewById(R.id.edttxtListPriceDisplay);
            parentLayout = itemView.findViewById(R.id.layoutLeaseItem);
            rate = itemView.findViewById(R.id.rbListing);
        }
    }
}
