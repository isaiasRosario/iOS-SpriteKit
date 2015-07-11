package com.fullsail.multiactivityjava2week3;

import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;


/**
 * Created by isaiasrosario on 3/19/15.
 */
public class AddFrag extends Fragment {

   private View rootView;

   @Override
   public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

      super.onCreateView(inflater, container, savedInstanceState);

      rootView =  inflater.inflate(R.layout.add_frag, container, false);

      Context cont = getActivity().getApplicationContext();

      return rootView;
   }

   @Override
   public void onActivityCreated(Bundle savedInstanceState){
      super.onActivityCreated(savedInstanceState);

      getActivity().findViewById(R.id.button).setOnClickListener(new View.OnClickListener() {

         @Override
         public void onClick(View v) {

            ListFrag frag = new ListFrag();

            Bundle bundle = new Bundle();
            bundle.putString("F_NAME", "John");
            bundle.putString("L_NAME", "Smith");
            bundle.putInt("AGE", 2);
            frag.setArguments(bundle);

            FragmentManager fragManager;

            Fragment listFr = new ListFrag();
            // consider using Java coding conventions (upper first char class names!!!)
            FragmentTransaction transaction = getFragmentManager().beginTransaction();

            // Replace whatever is in the fragment_container view with this fragment,
            // and add the transaction to the back stack
            transaction.replace(R.id.addFrag, listFr);
            transaction.addToBackStack(null);

            // Commit the transaction
            transaction.commit();
         }


      });
   }


}
