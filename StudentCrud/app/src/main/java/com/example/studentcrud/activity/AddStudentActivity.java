package com.example.studentcrud.activity;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.studentcrud.R;
import com.example.studentcrud.model.Student;
import com.example.studentcrud.service.ApiService;
import com.example.studentcrud.util.ApiClient;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.google.gson.Gson;

import java.util.Calendar;
import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddStudentActivity extends AppCompatActivity {

    private TextInputEditText editTextDob;
    private TextInputLayout editTextDate;
    private EditText textName, textClass, textAge, textAddress;
    private Button btnSave;
    private ApiService apiService = ApiClient.getApiService();
    private boolean isEditMode = false;

    private long studentId = -1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_add_student);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });
        //enable the up button (back button) in the actionbar
        if(getSupportActionBar() != null){
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        editTextDate = findViewById(R.id.editTextDate);
        editTextDob = findViewById(R.id.editTextDob);
        textName = findViewById(R.id.textName);
        textClass = findViewById(R.id.textClass);
        textAge = findViewById(R.id.textAge);
        textAddress = findViewById(R.id.textAddress);
        btnSave = findViewById(R.id.btnSave);

        //update
        Intent intent = getIntent();
        if(getIntent().hasExtra("student")){
            Student student = new Gson()
                    .fromJson(intent.getStringExtra("student"), Student.class);
            studentId = student.getId();

            textName.setText(student.getName());
            textClass.setText(student.getClazz());
            textAge.setText(String.valueOf(student.getAge()));
            textAddress.setText(student.getAddress());
            editTextDob.setText(student.getDob());

            btnSave.setText(R.string.update);
            isEditMode = true;
        }
        editTextDate.setEndIconOnClickListener(v -> showDatePicker());
        btnSave.setOnClickListener(v -> saveStudent());

    }


    @Override
    public boolean onSupportNavigateUp(){
        finish();
        return true;
    }

    private void showDatePicker(){
        final Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog picker = new DatePickerDialog(this,
                (view, year1, month1, day1) -> {
                    String dob = String.format(Locale.US, "%04d-%02d-%02d", year1, month1 + 1, day1);
                    editTextDob.setText(dob);
                },
                year, month, day);
        picker.show();

    }

    private void saveStudent(){
        String name = textName.getText().toString().trim();
        String clazz = textClass.getText().toString().trim();
        Integer age = Integer.parseInt(textAge.getText().toString().trim());
        String address = textAddress.getText().toString().trim();
        assert editTextDob.getText() != null;
        String dateOfBirthday = editTextDob.getText().toString().trim();

        Student student = new Student();
        if(isEditMode){
            student.setId(studentId);
        }


        student.setName(name);
        student.setClazz(clazz);
        student.setAge(age);
        student.setAddress(address);
        student.setDob(dateOfBirthday);

        Call<Student> call;
        if(isEditMode){
            call = apiService.updateStudent(studentId, student);
        }else {
            call = apiService.saveStudent(student);
        }



        call.enqueue(new Callback<>(){

            @Override
            public void onResponse(Call<Student> call, Response<Student> response) {
                if(response.isSuccessful()){
                    Toast.makeText(AddStudentActivity.this, "Student saved successfull!",
                            Toast.LENGTH_SHORT).show();
                    clearForm();
                    Intent intent = new Intent(AddStudentActivity.this, ListStudentActivity.class);
                    startActivity(intent);
                    finish();
                }else {
                    Toast.makeText(AddStudentActivity.this, "Fail to saved student"
                    + response.message(), Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onFailure(Call<Student> call, Throwable t) {
                Toast.makeText(AddStudentActivity.this, "Error : " + t.getMessage(),
                        Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void clearForm(){
        textName.setText("");
        textClass.setText("");
        textAge.setText("");
        textAddress.setText("");
        editTextDob.setText("");
    }
}