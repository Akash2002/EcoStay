package com.ecostay;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;

import java.util.ArrayList;

public class RecyclerViewAdapter extends RecyclerView.Adapter<RecyclerViewAdapter.ViewHolder> {

    private ArrayList<String> mLeaseNames = new ArrayList<>();
    private ArrayList<String> mLeaseImage = new ArrayList<>();
    private ArrayList<String> mUserID = new ArrayList<>();
    private Context mContext;

    public RecyclerViewAdapter(ArrayList<String> mLeaseNames, ArrayList<String> mLeaseImage, ArrayList<String> inUserID, Context mContext) {
        this.mLeaseNames = mLeaseNames;
        this.mLeaseImage = mLeaseImage;
        this.mUserID = inUserID;
        this.mContext = mContext;
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

        holder.parentLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Log.d("RecylcerViewAdapter", mUserID.get(position));

                Intent goToListingInfo = new Intent(mContext, ListingInfo.class);
                goToListingInfo.putExtra("Listing Path", mLeaseNames.get(position));
                goToListingInfo.putExtra("User", mUserID.get(position));
                mContext.startActivity(goToListingInfo);
            }
        });
    }

    @Override
    public int getItemCount() {
        return mLeaseImage.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder{

        ImageView image;
        TextInputLayout textLayout;
        TextInputEditText editText;
        RelativeLayout parentLayout;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            image = itemView.findViewById(R.id.image);
            textLayout = itemView.findViewById(R.id.txtLeaseName);
            editText = itemView.findViewById(R.id.edttxtLeaseName);
            parentLayout = itemView.findViewById(R.id.layoutLeaseItem);
        }
    }
}
