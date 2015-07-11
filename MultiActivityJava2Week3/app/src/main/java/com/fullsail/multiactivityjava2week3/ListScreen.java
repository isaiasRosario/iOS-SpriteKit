package com.fullsail.multiactivityjava2week3;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.View;

/**
 * Created by isaiasrosario on 3/19/15.
 */
public class ListScreen extends Activity {

   FragmentManager fragManager;

   @Override
   protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setContentView(R.layout.list_screen);

      fragManager = getFragmentManager();
      fragManager.beginTransaction().replace(R.id.listFrag, new ListFrag()).commit();
   }


}
