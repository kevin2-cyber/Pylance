package com.kimikevin.splashapp;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.kimikevin.splashapp.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        getSplashScreen().clearOnExitAnimationListener();
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        super.onCreate(savedInstanceState);
        setContentView(binding.getRoot());
    }

}