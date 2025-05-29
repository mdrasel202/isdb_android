package com.example.studentcrud;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.studentcrud.activity.AddStudentActivity;
import com.example.studentcrud.activity.ListStudentActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        Button btnAddStudent = findViewById(R.id.btnAddStudent);
        Button btnListStudent = findViewById(R.id.btnListStudent);

        btnAddStudent.setOnClickListener(v -> navigateToStudentPage());
        btnListStudent.setOnClickListener(v -> navigationToStudentList());
    }

    private void navigationToStudentList() {
        Intent intent = new Intent(MainActivity.this, ListStudentActivity.class);
        startActivity(intent);
    }

    private void navigateToStudentPage() {
        Intent intent = new Intent(MainActivity.this, AddStudentActivity.class);
        startActivity(intent);
    }
}