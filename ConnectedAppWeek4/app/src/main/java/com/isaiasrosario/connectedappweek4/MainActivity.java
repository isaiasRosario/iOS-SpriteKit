package com.isaiasrosario.connectedappweek4;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.SimpleAdapter;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;


public class MainActivity extends Activity implements View.OnClickListener {

    JSONObject redditInfo;
    GetInfo getInfo;
    private String searchText;
    private final String KEY = "title";
    private final String VALUE = "author";
    EditText input;
    ListView list;
    ProgressBar bar;
    Button button;
    String tag = "";







    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        button = (Button) findViewById(R.id.button);
        button.setOnClickListener(this);
        input = (EditText) findViewById(R.id.editText);
        bar = (ProgressBar) findViewById(R.id.progressBar);
        list = (ListView) findViewById(R.id.listView);

        bar.setVisibility(View.INVISIBLE);

    }

    @Override
    public void onClick(View view){json();}

    private void json(){
        searchText = input.getText().toString();
        IsThereConnection connectivity = new IsThereConnection(getApplicationContext());

        boolean connecting = connectivity.isConnected();
        if (connecting){
            bar.setVisibility(View.VISIBLE);
            getInfo = new GetInfo();
            getInfo.execute();

        }else {
            bar.setVisibility(View.INVISIBLE);
            error();
        }
    }

    private class GetInfo extends AsyncTask<Object, Void, JSONObject>{

        @Override
        protected JSONObject doInBackground(Object[] params) {
            int responseCode;
            JSONObject jsonResponse = null;
            StringBuilder strBuild = new StringBuilder();
            HttpClient client = new DefaultHttpClient();
            UrlEncoder();

            HttpGet get = new HttpGet("http://www.reddit.com/search.json?q=" + searchText);


            try {
                HttpResponse response = client.execute(get);
                StatusLine statusLine = response.getStatusLine();
                responseCode = statusLine.getStatusCode();

                if (responseCode == HttpURLConnection.HTTP_OK){
                    HttpEntity entity = response.getEntity();
                    InputStream content = entity.getContent();
                    BufferedReader reader = new BufferedReader(new InputStreamReader(content));

                    String line;
                    while ((line = reader.readLine()) != null){
                    strBuild.append(line);

                }
                    jsonResponse = new JSONObject(strBuild.toString());
            }
            }catch (IOException e){
                e.printStackTrace();
            }catch (JSONException e){
                e.printStackTrace();
            }
            return jsonResponse;
        }

        protected void onPostExecute(JSONObject result){
            redditInfo = result;

           System.out.println(redditInfo);
            runJSON();
        }
    }

    private void runJSON() {

        bar.setVisibility(View.INVISIBLE);

        if (redditInfo == null) {
            error();
        } else {
            try{
                JSONArray jsonItems = redditInfo.getJSONArray("children");
            ArrayList<HashMap<String, String>> data = new ArrayList<HashMap<String, String>>();

                System.out.println(jsonItems);

            for (int i = 0; i < jsonItems.length(); i++) {
                JSONObject post = jsonItems.getJSONObject(i);

                String title = post.getString(KEY);
                title = Html.fromHtml(title).toString();
                String user = post.optString(VALUE, "n/a");
                user = Html.fromHtml(user).toString();

                HashMap<String, String> searchInfo = new HashMap<String, String>();
                searchInfo.put(KEY, title);
                searchInfo.put(VALUE, user);
                data.add(searchInfo);

                System.out.println(data);

                String[] keys = {KEY, VALUE};
                int[] items = {android.R.id.text1, android.R.id.text2};
                SimpleAdapter adapter = new SimpleAdapter(this, data, android.R.layout.simple_expandable_list_item_2, keys, items);

                list.setAdapter(adapter);

            }

            }catch(JSONException e){
                Log.e(tag, "exception:", e);
                error();

            }
        }

    }

    private void error(){

        AlertDialog.Builder alert = new AlertDialog.Builder(this);
        alert.setTitle("Not Connected");
        alert.setMessage("Check Your Connection");
        alert.setNegativeButton("Close", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

            }
        });

        alert.show();
    }

    private void UrlEncoder(){
        try{
            searchText = URLEncoder.encode(searchText, "UTF-8");
        }catch (UnsupportedEncodingException e){
            e.printStackTrace();
        }
    }

}
