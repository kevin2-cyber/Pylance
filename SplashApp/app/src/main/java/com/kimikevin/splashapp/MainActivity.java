package com.kimikevin.splashapp;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.kimikevin.splashapp.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
//        getSplashScreen().setSplashScreenTheme(R.style.SplashTheme);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        super.onCreate(savedInstanceState);
        setTheme(R.style.Theme_SplashApp);
        setContentView(binding.getRoot());
    }

}