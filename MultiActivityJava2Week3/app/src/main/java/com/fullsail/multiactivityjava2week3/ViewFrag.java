package com.fullsail.multiactivityjava2week3;

import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by isaiasrosario on 3/19/15.
 */
public class ViewFrag extends Fragment {

   private View rootView;

   @Override
   public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

      super.onCreateView(inflater, container, savedInstanceState);

      rootView =  inflater.inflate(R.layout.view_frag, container, false);

      Context cont = getActivity().getApplicationContext();

      return rootView;
   }
}
