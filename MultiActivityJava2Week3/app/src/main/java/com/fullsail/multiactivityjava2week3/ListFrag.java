package com.fullsail.multiactivityjava2week3;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by isaiasrosario on 3/19/15.
 */
public class ListFrag extends Fragment {
   private View rootView;

   @Override
   public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

      super.onCreateView(inflater, container, savedInstanceState);

      rootView =  inflater.inflate(R.layout.list_frag, container, false);

      Context cont = getActivity().getApplicationContext();

      return rootView;
   }

   @Override
   public void onActivityCreated(Bundle savedInstanceState){
      super.onActivityCreated(savedInstanceState);

      Bundle bundle = this.getArguments();

      String first = bundle.getString("F_NAME");
      String last = bundle.getString("L_NAME");
      Number age = bundle.getInt("AGE");

      System.out.println(first + last + age);


   }
}
