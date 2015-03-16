package com.fullsail.fragmentsjava2week1;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;

import com.fullsail.fragmentsjava2week1.libs.ManageStorage;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;


/**
 * Created by isaiasrosario on 3/13/15.
 */
public class FragmentOne extends Fragment implements AdapterView.OnItemClickListener{

   FragmentOneListener listener;

   String condition = "";
   String returnData = "";
   String high = "";
   String low = "";

   private View rootView;
   ArrayList<String> arr = new ArrayList<String>();
   ArrayList<String> arr2 = new ArrayList<String>();
   ArrayList<String> arr3 = new ArrayList<String>();
   ArrayList<String> arr4 = new ArrayList<String>();
   ArrayList<String> arrN = new ArrayList<>(Arrays.asList("No Internet", "No Internet", "No Internet", "No Internet", "No Internet"));
   ListView lv;
   ArrayAdapter adapter;

   Context cont = null;


   @Override
   public void onAttach(Activity activity){
      super.onAttach(activity);

      if (activity instanceof FragmentOneListener){
         listener = (FragmentOneListener) activity;

      }else {
         throw  new IllegalArgumentException("ERROR CHECK IT OUT!");
      }
   }

   @Override
   public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

      super.onCreateView(inflater, container, savedInstanceState);

      rootView =  inflater.inflate(R.layout.frag_one, container, false);

      Context cont = getActivity().getApplicationContext();

      return rootView;
   }

   @Override
   public void onActivityCreated(Bundle savedInstanceState){
      super.onActivityCreated(savedInstanceState);

      super.onActivityCreated(savedInstanceState);

      lv = (ListView)rootView.findViewById(R.id.listView);
      //lv.setOnItemClickListener((AdapterView.OnItemClickListener) this);
      lv.setOnItemClickListener(this);


      getActivity().findViewById(R.id.button).setOnClickListener(new View.OnClickListener(){

         @Override
         public void onClick(View v){
            EditText et = (EditText) getActivity().findViewById(R.id.editText);

            returnData = et.getText().toString();

            boolean digitsOnly = TextUtils.isDigitsOnly(returnData);
            String url = "";
            System.out.println(digitsOnly);

            Boolean network = ((MainActivity) getActivity()).isNetworkAvailable();


            if(!network){

               ((MainActivity) getActivity()).networkAlert();

               adapter = new ArrayAdapter<String>(getActivity(),
                  android.R.layout.simple_list_item_1 , arrN);
               lv.setAdapter(adapter);

               listener.clickListener("No Connection", "OOPS NO NETWORK", "No Connection", "No Connection");

            } else {

               if (digitsOnly){
                  String zipCode = returnData;
                  if (zipCode.length() == 5){
                     zipCode = returnData;
                     url = "https://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20weather.bylocation%20WHERE%20location%3D%22" + zipCode + "%22&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";

                     new MyAsyncTask().execute(url);
                     //listener.clickListener(returnData, condition);

                  }else {
                     ((MainActivity) getActivity()).alert();
                     System.out.println("NOPE NO ZIPCODE!");
                  }
               }else {
                  // zipCode = data;
                  ((MainActivity) getActivity()).alert();
                  System.out.println("NOPE NO ZIPCODE!");
               }

            }
         }
      });
   }

   @Override
   public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

      Boolean network = ((MainActivity) getActivity()).isNetworkAvailable();

      if(!network){

         ((MainActivity) getActivity()).networkAlert();

         listener.clickListener("No Connection", "OOPS NO NETWORK", "No Connection", "No Connection");

      }else {

         returnData = "\n"+"Condition: " + arr2.get(position);
         high = "\n"+"High: " + arr3.get(position);
         low = "\n"+"Low: " + arr4.get(position);

         listener.clickListener(returnData, condition, high, low);

      }

   }

   private class MyAsyncTask extends AsyncTask<String, Void, Void> {

      @Override
      protected void onPreExecute() {


      }

      @Override
      protected Void doInBackground(String... params) {


         try {
            HttpClient client = new DefaultHttpClient();
            HttpPost post = new HttpPost(params[0]);
            HttpResponse response = client.execute(post);

            int status = response.getStatusLine().getStatusCode();
            if (status == 200){

               HttpEntity entity = response.getEntity();
               String data = EntityUtils.toString(entity);

               JSONObject obj1 = new JSONObject(data);
               JSONObject obj2 = obj1.getJSONObject("query").getJSONObject("results");
               JSONObject obj3 = obj2.getJSONObject("weather").getJSONObject("rss");
               JSONObject obj4 = obj3.getJSONObject("channel").getJSONObject("item");

               JSONObject location = obj3.getJSONObject("channel").getJSONObject("location");
               String city = location.getString("city");
               String state = location.getString("region");
               String country = location.getString("country");
               condition = city+", "+state+" "+country;

               JSONArray arrObj = obj4.getJSONArray("forecast");
               System.out.println(arrObj);

               listener.clickListener(null, condition, null, null);


               for (int i=0; i<arrObj.length(); i++){

                  JSONObject forecast = arrObj.getJSONObject(i);

                  arr.add(forecast.getString("date"));
                  arr2.add(forecast.getString("text"));
                  arr3.add(forecast.getString("high"));
                  arr4.add(forecast.getString("low"));

                  System.out.println("Condition: "+forecast.getString("text"));
                  System.out.println("High: "+forecast.getString("high"));
                  System.out.println("Low: " + forecast.getString("low"));
                  System.out.println("Day: "+forecast.getString("day"));
                  System.out.println("Date: "+forecast.getString("date"));
               }

            }
         } catch (ClientProtocolException e){
            e.printStackTrace();
         }catch (IOException e) {
            e.printStackTrace();
         } catch (JSONException e) {
            e.printStackTrace();
         }
         return null;
      }



      //@Override
      protected void onPostExecute(Void results){
         super.onPostExecute(results);
         System.out.println(results);
         System.out.println(arr);

         adapter = new ArrayAdapter<String>(getActivity(),
            android.R.layout.simple_list_item_1 , arr);
         lv.setAdapter(adapter);

         //ManageStorage.SaveData(arr, cont);


      }
   }

}
