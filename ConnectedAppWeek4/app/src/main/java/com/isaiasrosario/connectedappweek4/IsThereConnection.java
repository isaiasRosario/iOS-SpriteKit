package com.isaiasrosario.connectedappweek4;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

/**
 * Created by isaiasrosario on 1/26/14.
 */
public class IsThereConnection {

    private Context _context;

    public IsThereConnection(Context context){

        this._context = context;
    }
    public boolean isConnected() {
        ConnectivityManager connectivity = (ConnectivityManager) _context.getSystemService(Context.CONNECTIVITY_SERVICE);

        NetworkInfo[] info = connectivity.getAllNetworkInfo();
        if (info != null){
            for (int i = 0; i < info.length; i++)
                if (info[i].getState() == NetworkInfo.State.CONNECTED)
                {
                    return true;
                }
        }
        return false;

    }

}
