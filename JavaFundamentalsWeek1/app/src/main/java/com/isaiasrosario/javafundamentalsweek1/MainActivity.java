package com.isaiasrosario.javafundamentalsweek1;

import android.app.Activity;
import android.os.Bundle;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import java.util.ArrayList;
import java.util.HashSet;
import android.view.inputmethod.InputMethodManager;



public class MainActivity extends Activity implements View.OnClickListener, AdapterView.OnItemClickListener {

    TextView enteredText;
    TextView totalItem;
    TextView averageItem;
    ListView listItems;
    ArrayList<String> listArray = new ArrayList<String>();
    ArrayAdapter arrAdapter;
    HashSet listHashSet = new HashSet();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button button = (Button) findViewById(R.id.button);
        button.setOnClickListener(this);

        listItems = (ListView) findViewById(R.id.listView);
        arrAdapter = new ArrayAdapter(this, android.R.layout.simple_list_item_1, listArray);
        listItems.setAdapter(arrAdapter);
        listItems.setOnItemClickListener(this);

        enteredText = (TextView) findViewById(R.id.editText);
        totalItem = (TextView) findViewById(R.id.textView3);
        averageItem = (TextView) findViewById(R.id.textView4);
    }

    @Override
    public void onClick(View view) {
        InputMethodManager inputManager = (InputMethodManager)
                getSystemService(Context.INPUT_METHOD_SERVICE);

        inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(),
                InputMethodManager.HIDE_NOT_ALWAYS);

        if (enteredText.getText().toString().equals("")){
            Context context = getApplicationContext();
            CharSequence text = ("You Did Not Enter Item");
            int duration = Toast.LENGTH_SHORT;
            Toast toast = Toast.makeText(context, text, duration);
            toast.show();
        }else {
            listArray.add(enteredText.getText().toString());

            listHashSet.addAll(listArray);
            listArray.clear();
            listArray.addAll(listHashSet);
            arrAdapter.notifyDataSetChanged();

            Context context = getApplicationContext();
            CharSequence text = (enteredText.getText().toString() + " was added!");
            int duration = Toast.LENGTH_SHORT;
            Toast toast =  Toast.makeText(context, text, duration);
            toast.show();

            int count = listArray.size();
            totalItem.setText("" + count);

            getAverage(listArray);

            enteredText.setText("");
        }
    }

    public void getAverage(ArrayList arrayList){

        int iTotal = 0;
        int iLength = 0;
        int iCount = 0;
        String item;

        for (int i = 0; i < arrayList.size(); i++){

            item = listArray.get(i);
            iLength = item.length();
            iTotal += iLength;
            iCount = i +1;

        }

        iLength = iTotal/iCount;

        averageItem.setText("" + iLength);
    }
    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        AlertDialog.Builder alert = new AlertDialog.Builder(this);
        alert.setTitle("You Selected This Item!");
        alert.setMessage("" + listArray.get(position));
        alert.setNegativeButton("Close", new DialogInterface.OnClickListener(){
            public void onClick(DialogInterface dialog, int whichButton){

            }
        });

        alert.show();

    }
}
