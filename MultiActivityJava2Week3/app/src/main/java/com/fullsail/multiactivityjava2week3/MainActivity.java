package com.fullsail.multiactivityjava2week3;

import android.app.Activity;
import android.app.FragmentManager;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;


public class MainActivity extends Activity {


   FragmentManager fragManager;

   @Override
   protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setContentView(R.layout.activity_main);

      fragManager = getFragmentManager();
      fragManager.beginTransaction().replace(R.id.addFrag, new AddFrag()).commit();
   }

}
