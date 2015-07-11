package com.fullsail.multiactivityjava2week3;

import android.app.Activity;
import android.app.FragmentManager;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;

/**
 * Created by isaiasrosario on 3/19/15.
 */
public class ViewScreen extends Activity {

   FragmentManager fragManager;

   @Override
   protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setContentView(R.layout.view_screen);

      fragManager = getFragmentManager();
      fragManager.beginTransaction().replace(R.id.viewFrag, new ViewFrag()).commit();
   }
}
