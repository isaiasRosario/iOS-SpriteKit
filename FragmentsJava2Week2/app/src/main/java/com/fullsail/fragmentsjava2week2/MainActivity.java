package com.fullsail.fragmentsjava2week2;

import android.app.AlertDialog;
import android.app.Fragment;
import android.app.FragmentManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;


public class MainActivity extends ActionBarActivity implements FragmentOneListener{

   FragmentManager fragManager;

   String color = "";

   @Override
   public void onCreate(Bundle savedInstanceState) {
      // Get any saved data
      super.onCreate(savedInstanceState);

      Boolean network = isNetworkAvailable();

      System.out.println(network);

      if(!network) networkAlert();

      setContentView(R.layout.activity_main);
      fragManager = getFragmentManager();
      fragManager.beginTransaction().replace(R.id.containerOne, new FragmentTwo()).commit();
      fragManager.beginTransaction().replace(R.id.containerTwo, new FragmentOne()).commit();


   }

   public boolean isNetworkAvailable() {
      ConnectivityManager connectivityManager
         = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
      NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
      return activeNetworkInfo != null && activeNetworkInfo.isConnected();
   }

   @Override
   public void clickListener(String data, String data1, String data2, String data3){

      //Toast.makeText(MainActivity.this, data, Toast.LENGTH_LONG).show();

      fragManager = getFragmentManager();
      Fragment frag2 = FragmentTwo.instancof(data, data1, data2, data3);
      fragManager.beginTransaction().replace(R.id.containerOne, frag2).commit();

   }



   @Override
   public boolean onCreateOptionsMenu(Menu menu) {
      // Inflate the menu; this adds items to the action bar if it is present.
      getMenuInflater().inflate(R.menu.menu_main, menu);
      return true;
   }


   @Override
   public boolean onOptionsItemSelected(MenuItem item) {
      // Handle action bar item clicks here. The action bar will
      // automatically handle clicks on the Home/Up button, so long
      // as you specify a parent activity in AndroidManifest.xml.
      int id = item.getItemId();

      //noinspection SimplifiableIfStatement
      if (id == R.id.action_settings) {

         Intent intent = new Intent(MainActivity.this, SettingsActivity.class);
         startActivity(intent);

         SharedPreferences mainPref = PreferenceManager.getDefaultSharedPreferences(this);

         color = mainPref.getString("PREF_LIST", "DEFAULT");

         System.out.println(color);
         changeColor();

         return true;
      }

      return super.onOptionsItemSelected(item);
   }

   public void alert(){

      AlertDialog.Builder alert = new AlertDialog.Builder(this);
      alert.setTitle("NOPE NO ZIP CODE!");
      alert.setMessage("Enter zip Code");
      alert.setNegativeButton("Close", new DialogInterface.OnClickListener(){
         public void onClick(DialogInterface dialog, int whichButton){

         }
      });

      alert.show();

   }

   public void networkAlert(){

      AlertDialog.Builder alert = new AlertDialog.Builder(this);
      alert.setTitle("No Internet!");
      alert.setMessage("No internet....");
      alert.setNegativeButton("Close", new DialogInterface.OnClickListener(){
         public void onClick(DialogInterface dialog, int whichButton){

         }
      });

      alert.show();

   }

   public void changeColor(){

      if (color.equals("DEFAULT")){
         ((EditText)findViewById(R.id.editText)).setHintTextColor(Color.BLACK);
         ((Button)findViewById(R.id.button)).setTextColor(Color.BLACK);
         ((TextView)findViewById(R.id.textView)).setTextColor(Color.BLACK);
         ((TextView)findViewById(R.id.textView2)).setTextColor(Color.BLACK);
         ((TextView)findViewById(R.id.textView3)).setTextColor(Color.BLACK);
         ((TextView)findViewById(R.id.textView4)).setTextColor(Color.BLACK);
      }
      if (color.equals("YELLOW")){
         ((EditText)findViewById(R.id.editText)).setHintTextColor(Color.YELLOW);
         ((Button)findViewById(R.id.button)).setTextColor(Color.YELLOW);
         ((TextView)findViewById(R.id.textView)).setTextColor(Color.YELLOW);
         ((TextView)findViewById(R.id.textView2)).setTextColor(Color.YELLOW);
         ((TextView)findViewById(R.id.textView3)).setTextColor(Color.YELLOW);
         ((TextView)findViewById(R.id.textView4)).setTextColor(Color.YELLOW);
      }
      if (color.equals("RED")){
         ((EditText)findViewById(R.id.editText)).setHintTextColor(Color.RED);
         ((Button)findViewById(R.id.button)).setTextColor(Color.RED);
         ((TextView)findViewById(R.id.textView)).setTextColor(Color.RED);
         ((TextView)findViewById(R.id.textView2)).setTextColor(Color.RED);
         ((TextView)findViewById(R.id.textView3)).setTextColor(Color.RED);
         ((TextView)findViewById(R.id.textView4)).setTextColor(Color.RED);
      }
      if (color.equals("MAGENTA")){
         ((EditText)findViewById(R.id.editText)).setHintTextColor(Color.MAGENTA);
         ((Button)findViewById(R.id.button)).setTextColor(Color.MAGENTA);
         ((TextView)findViewById(R.id.textView)).setTextColor(Color.MAGENTA);
         ((TextView)findViewById(R.id.textView2)).setTextColor(Color.MAGENTA);
         ((TextView)findViewById(R.id.textView3)).setTextColor(Color.MAGENTA);
         ((TextView)findViewById(R.id.textView4)).setTextColor(Color.MAGENTA);
      }
   }
}
