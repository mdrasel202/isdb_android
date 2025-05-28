package com.example.studentcrud.service;

import com.example.studentcrud.model.Student;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;

public interface ApiService{
    @POST("student")
    Call<Student> saveStudent(@Body Student student);

    @GET
    Call<List<Student>> getAllStudent();
}
