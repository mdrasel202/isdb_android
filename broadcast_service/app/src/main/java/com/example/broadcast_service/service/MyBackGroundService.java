package com.example.broadcast_service.service;

import static android.content.ContentValues.TAG;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

public class MyBackGroundService extends Service {
    public MyBackGroundService() {
    }
    private Handler handler;
    private Runnable runnable;
    private int counter = 0;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "Service Crated");
        Toast.makeText(this, "Service Create", Toast.LENGTH_SHORT).show();

        handler = new Handler();
        runnable = new Runnable() {
            @Override
            public void run() {
                counter++;
                Log.d(TAG, "Service running....Counter: " + counter);

                Toast.makeText(MyBackGroundService.this, "Service running : " + counter, Toast.LENGTH_SHORT).show();

                handler.postDelayed(this, 5000);
            }
        };
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "Service Started Command");
        Toast.makeText(this, "Service Start Command", Toast.LENGTH_SHORT).show();

        handler.post(runnable);
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "Service Destroye");
        Toast.makeText(this, "Service Destroyed", Toast.LENGTH_SHORT).show();

        //stop the periodic task when the service is destroyed
        if(handler != null && runnable != null){
            handler.removeCallbacks(runnable);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }
}