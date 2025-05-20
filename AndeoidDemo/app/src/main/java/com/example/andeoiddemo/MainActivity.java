package com.example.andeoiddemo;

import android.annotation.SuppressLint;
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

import com.example.andeoiddemo.activity.EmployeeListActivity;
import com.example.andeoiddemo.model.Employee;
import com.example.andeoiddemo.service.ApiService;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;

import java.util.Calendar;
import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class MainActivity extends AppCompatActivity {

    private TextInputEditText editTextDob;
    private TextInputLayout dateLayout;

    private EditText textName, textEmail, textDesignation, numberAge, multilineAddress, decimalSalary;
    private Button btnSave;
    private ApiService apiService;

    @SuppressLint("MissingInflatedId")
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

        //Initialize views
        editTextDob = findViewById(R.id.editTextDob);
        dateLayout = findViewById(R.id.editTextDate2);
        textName = findViewById(R.id.textName);
        textEmail = findViewById(R.id.textEmail);
//        textDesignation = findViewById(R.id.te);
        numberAge = findViewById(R.id.textAge);
        multilineAddress = findViewById(R.id.editTextTextPostalAddress);
        decimalSalary = findViewById(R.id.textSalary);
        btnSave = findViewById(R.id.button);


        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl("http://10.02.2")
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        apiService = retrofit.create(ApiService.class);
//       dateLayout.setEndIconOnLongClickListener(v -> showDatePicker());

        btnSave.setOnClickListener(v -> saveEmployee());

    }

    private void saveEmployee() {
        String name = textName.getText().toString().trim();
        String email = textEmail.getText().toString().trim();
        String designation = textDesignation.getText().toString().trim();
        String address = multilineAddress.getText().toString().trim();
        int salary = Integer.parseInt(decimalSalary.getText().toString().trim());

        //Create Employee object
        Employee employee = new Employee();
        employee.setName(name);
        employee.setEmail(email);
        employee.setDesignation(designation);
        employee.setAddress(address);
        employee.setSalary(salary);

        //Make API call
        Call<Employee> call = apiService.saveEmployee(employee);
        String string = call.toString();
        System.out.println(string);
        call.enqueue(new Callback<Employee>() {
            @Override
            public void onResponse(Call<Employee> call, Response<Employee> response) {
                if (response.isSuccessful()) {
                    Toast.makeText(MainActivity.this, "Employee saved successfully!",
                            Toast.LENGTH_SHORT).show();
                    clearForm();
                    Intent intent = new Intent(MainActivity.this, EmployeeListActivity.class);
                    startActivity(intent);
                    finish();
                } else {
                    Toast.makeText(MainActivity.this, "Failed to save employe"
                            + response.message(), Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onFailure(Call<Employee> call, Throwable throwable) {
                Toast.makeText(MainActivity.this, "Error" + throwable.getMessage(),
                        Toast.LENGTH_SHORT).show();

            }
        });
    }

    private void clearForm() {
        textName.setText("");
        textEmail.setText("");
        textDesignation.setText("");
        multilineAddress.setText("");
        decimalSalary.setText("");
    }

    private void showDatePicker () {
    final Calendar calendar = Calendar.getInstance();
    int year = calendar.get(Calendar.YEAR);
    int month = calendar.get(Calendar.MONTH);
    int day = calendar.get(Calendar.DAY_OF_MONTH);

    DatePickerDialog picker = new DatePickerDialog(this,
            (view, year1, month1, day1) -> {
                String dob = String.format(Locale.US, "%04d-%02d-%02d", year1, month1, day1);
                editTextDob.setText(dob);
            },
            year, month, day);
    picker.show();
}
}