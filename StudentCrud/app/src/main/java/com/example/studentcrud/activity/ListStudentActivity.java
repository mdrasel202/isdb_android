package com.example.studentcrud.activity;

import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.studentcrud.R;
import com.example.studentcrud.adapter.StudentAdapter;
import com.example.studentcrud.model.Student;
import com.example.studentcrud.service.ApiService;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ListStudentActivity extends AppCompatActivity {

    private static final String TAG = "ListStudentActivity" ;
    private RecyclerView recyclerView;
    private StudentAdapter studentAdapter;
    private List<Student> studentList = new ArrayList<>();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_list_student);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        //enable the up button (back button) in the actionbar
        if(getSupportActionBar() != null){
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        studentAdapter = new StudentAdapter(this, studentList);
        recyclerView = findViewById(R.id.studentRecyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(studentAdapter);

        fetchStudent();
    }

    @Override
    public boolean onSupportNavigateUp(){
        finish();
        return true;
    }
    private void fetchStudent(){
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl("http://10.0.2.2:8081/")
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ApiService apiService = retrofit.create(ApiService.class);
        Call<List<Student>> call = apiService.getAllStudent();

        call.enqueue(new Callback<List<Student>>() {
            @Override
            public void onResponse(Call<List<Student>> call, Response<List<Student>> response) {
                if(response.isSuccessful()){
                    List<Student> students = response.body();
                    for(Student stu : students){
                        Log.d(TAG, "ID : " + stu.getId() + "Name : " + stu.getName() + "Address : " + stu.getAddress());
                    }
                    studentList.clear();
                    studentList.addAll(students);
                    studentAdapter.notifyDataSetChanged();
                }else {
                    Log.d(TAG, "API Response Error" + response.code());
                }
            }

            @Override
            public void onFailure(Call<List<Student>> call, Throwable t) {
                Log.e(TAG, "API Call Failed" + t.getMessage());

            }
        });
    }
}