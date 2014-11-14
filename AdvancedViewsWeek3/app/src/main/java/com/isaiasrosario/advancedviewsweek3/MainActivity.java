package com.isaiasrosario.advancedviewsweek3;

import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.HashMap;


public class MainActivity extends Activity {

    ListView listView;
    Spinner spinnerView;
    ArrayList<MovieInfo> movies;
    public HashMap<Integer, MovieInfo> movieInfo = new HashMap<Integer, MovieInfo>();
    public class CustomAdapter extends BaseAdapter {
        private Integer[] keys;

        public CustomAdapter(HashMap<Integer, MovieInfo> data) {
            movieInfo = data;
            keys = movieInfo.keySet().toArray(new Integer[data.size()]);
        }

        @Override
        public int getCount() {
            return movieInfo.size();
        }

        @Override
        public Object getItem(int position) {
            return movieInfo.get(keys[position]);
        }

        @Override
        public long getItemId(int movieId) { return movieId; }

        @Override
        public View getView(int position, View convertView, ViewGroup parent){

            MovieInfo movie = (MovieInfo) getItem(position);

            final View result;

            if(convertView == null){
                result = LayoutInflater.from(parent.getContext()).inflate(R.layout.item, parent, false);
            }else {
                result = convertView;
            }

            if (getResources().getConfiguration().orientation == 1){
                ((TextView) result.findViewById(R.id.movie_portrait)).setText(movie.getMovieName());
            }else {
                ((TextView) result.findViewById(R.id.movie_landscape)).setText(movie.getMovieName());
            }
            return result;

        }



    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        listView = (ListView) findViewById(R.id.listView);
        spinnerView = (Spinner) findViewById(R.id.spinner);
        movies = new ArrayList<MovieInfo>();

        MovieInfo mov1 = new MovieInfo();
        mov1.setMovieName("Frozen");
        mov1.setMovieRating("PG");
        mov1.setMovieTime("106 Minutes");
        mov1.setMovieDetail("Disney movie about winter.");
        movieInfo.put(0, mov1);

        MovieInfo mov2 = new MovieInfo();
        mov2.setMovieName("Cars");
        mov2.setMovieRating("PG");
        mov2.setMovieTime("90 Minutes");
        mov2.setMovieDetail("Disney movie about cars.");
        movieInfo.put(1, mov2);

        MovieInfo mov3 = new MovieInfo();
        mov3.setMovieName("Finding Nemo");
        mov3.setMovieRating("PG");
        mov3.setMovieTime("110 Minutes");
        mov3.setMovieDetail("Disney movie about fish.");
        movieInfo.put(2, mov3);

        MovieInfo mov4 = new MovieInfo();
        mov4.setMovieName("Planet Of the Apes");
        mov4.setMovieRating("PG-13");
        mov4.setMovieTime("120 Minutes");
        mov4.setMovieDetail("Movie about smart monkeys.");
        movieInfo.put(3, mov4);

        MovieInfo mov5 = new MovieInfo();
        mov5.setMovieName("Big Hero 6");
        mov5.setMovieRating("PG");
        mov5.setMovieTime("9 Minutes");
        mov5.setMovieDetail("Movie about a robot blob.");
        movieInfo.put(4, mov5);

        if (getResources().getConfiguration().orientation == 2) {

            listView = (ListView) findViewById(R.id.listView);
            CustomAdapter adapter = new CustomAdapter(movieInfo);
            listView.setAdapter(adapter);

            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    TextView mName = (TextView) findViewById(R.id.name);
                    mName.setText(movieInfo.get(position).getMovieName());
                    TextView mRating = (TextView) findViewById(R.id.rating);
                    mRating.setText(movieInfo.get(position).getMovieRating());
                    TextView mTime = (TextView) findViewById(R.id.time);
                    mTime.setText(movieInfo.get(position).getMovieTime());
                    TextView mDetail = (TextView) findViewById(R.id.details);
                    mDetail.setText(movieInfo.get(position).getMovieDetail());
                }

            });

        }


        if (getResources().getConfiguration().orientation == 1){
            spinnerView = (Spinner) findViewById(R.id.spinner);
            CustomAdapter adapter = new CustomAdapter(movieInfo);
            spinnerView.setAdapter(adapter);

            ArrayAdapter adapter1 = ArrayAdapter.createFromResource(this, R.array.movieArray, android.R.layout.simple_spinner_item);
            adapter1.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            spinnerView.setAdapter(adapter1);

            spinnerView.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l){
                    TextView mName = (TextView) findViewById(R.id.name);
                    mName.setText(movieInfo.get(spinnerView.getFirstVisiblePosition()).getMovieName());
                    TextView mRating = (TextView) findViewById(R.id.rating);
                    mRating.setText(movieInfo.get(spinnerView.getFirstVisiblePosition()).getMovieRating());
                    TextView mTime = (TextView) findViewById(R.id.time);
                    mTime.setText(movieInfo.get(spinnerView.getFirstVisiblePosition()).getMovieTime());
                    TextView mDetail = (TextView) findViewById(R.id.details);
                    mDetail.setText(movieInfo.get(spinnerView.getFirstVisiblePosition()).getMovieDetail());

                }

                public void onNothingSelected(AdapterView<?> adapterView){
                    System.out.println("Nothing");
                }

            });







        }

    }

}