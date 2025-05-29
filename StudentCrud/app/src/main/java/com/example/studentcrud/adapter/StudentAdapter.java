package com.example.studentcrud.adapter;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.studentcrud.R;
import com.example.studentcrud.activity.AddStudentActivity;
import com.example.studentcrud.model.Student;
import com.example.studentcrud.service.ApiService;
import com.google.gson.Gson;

import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class StudentAdapter extends RecyclerView.Adapter<StudentAdapter.StudentViewHolder> {

    private Context context;
    private List<Student> studentList;
    private ApiService apiService;

    public StudentAdapter(Context context, List<Student> studentList, ApiService apiService) {
        this.context = context;
        this.studentList = studentList;
        this.apiService = apiService;
    }

    @NonNull
    @Override
    public StudentViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater
                .from(parent.getContext())
                .inflate(R.layout.item_student, parent , false );
        return new StudentViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull StudentViewHolder holder, int position) {
        Student student = studentList.get(position);
        holder.nameText.setText(student.getName());
        holder.addrssText.setText(student.getAddress());

        holder.updateButton.setOnClickListener(v ->{
            Log.d("Update", "Update clicked for" + student.getName());
            Intent intent = new Intent(context, AddStudentActivity.class);
            intent.putExtra("employee", new Gson(). toJson(student));
            context.startActivity(intent);
        });

        holder.deleteButton.setOnClickListener( v ->{
            Log.d("Delete", "Delete clicked for" + student.getName());
            new AlertDialog.Builder(context)
                    .setTitle("Delete")
                    .setMessage("Are you sure you want to delete" + student.getName() + "?")
                    .setPositiveButton("Yes",
                            (dialog, which) ->  apiService.deleteStudent(student.getId())
                                    .enqueue(new Callback<>() {
                                        @Override
                                        public void onResponse(@NonNull Call<Void> call, @NonNull Response<Void> response) {
                                            if(response.isSuccessful()){
                                                int adapterPosition = holder.getAdapterPosition();
                                                if(adapterPosition != RecyclerView.NO_POSITION){
                                                    studentList.remove(adapterPosition);
                                                    notifyItemRemoved(adapterPosition);
                                                    notifyItemRangeChanged(adapterPosition, studentList.size());
                                                    Toast.makeText(context,"Deleted successfully",
                                                            Toast.LENGTH_SHORT).show();
                                                }
                                            }else {
                                                Toast.makeText(context, "Failed to delete", Toast.LENGTH_SHORT). show();
                                            }
                                        }

                                        @Override
                                        public void onFailure(@NonNull Call<Void> call, @NonNull Throwable t) {
                                            Toast.makeText(context, "Error " + t.getMessage(), Toast.LENGTH_SHORT).show();
                                        }
                                    }))
                    .setNegativeButton("Cancel", null)
                    .show();

        });
    }

    @Override
    public int getItemCount() {
        return studentList.size();
    }

    public static class StudentViewHolder extends RecyclerView.ViewHolder {

        TextView nameText, addrssText;

        Button updateButton, deleteButton;
        public StudentViewHolder(@NonNull View itemView) {
            super(itemView);
            nameText = itemView.findViewById(R.id.nameText);
            addrssText = itemView.findViewById(R.id.addrssText);
            updateButton = itemView.findViewById(R.id.updateButton);
            deleteButton = itemView.findViewById(R.id.deleteButton);
        }
    }
}
