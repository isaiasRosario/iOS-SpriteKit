package com.fullsail.fragmentsjava2week2;

import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.widget.Toast;

/**
 * Created by isaiasrosario on 3/15/15.
 */
public class SettingsFragment extends PreferenceFragment{

   @Override
   public void onCreate(Bundle savedInstanceState){
      super.onCreate(savedInstanceState);
      addPreferencesFromResource(R.xml.settings);
   }

   @Override
   public void onActivityCreated(Bundle savedInstanceState){
      super.onActivityCreated(savedInstanceState);

      Preference preference = findPreference("PREF_CLICK");
      preference.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener(){
         @Override
      public boolean onPreferenceClick(Preference preference){
           Toast.makeText(getActivity(), "You selected the preference button", Toast.LENGTH_LONG).show();

            return false;
         }

      });


   }
}
