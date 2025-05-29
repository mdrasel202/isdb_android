package com.example.studentcrud.service;

import com.example.studentcrud.model.Student;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;

public interface ApiService{
    @POST("student")
    Call<Student> saveStudent(@Body Student student);

    @GET
    Call<List<Student>> getAllStudent();

    @PUT("student/{id}")
    Call<Student> updateStudent(@Path("id") Long id, @Body Student student);

    @DELETE
    Call<Void> deleteStudent(@Path("id") Long id);
}
