

import 'dart:io';

import 'package:empoyee_crud/models/online_employee.dart';
import 'package:empoyee_crud/screens/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AddEditOnLineEmployeeScreen extends StatefulWidget {
  final OnlineEmployee? employee;

  const AddEditOnLineEmployeeScreen({super.key, this.employee});

  @override
  State<AddEditOnLineEmployeeScreen> createState() =>
      _AddEditOnLineEmployeeScreenState();
}

class _AddEditOnLineEmployeeScreenState
extends State<AddEditOnLineEmployeeScreen>{
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _designationController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _salaryController = TextEditingController();
  File? _image;
  String? _imageUrl;
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    if(widget.employee != null){
      _nameController.text = widget.employee!.name;
      _emailController.text = widget.employee!.email;
      _designationController.text = widget.employee!.designation;
      _ageController.text = widget.employee!.age.toString();
      _addressController.text = widget.employee!.address;
      _dobController.text = widget.employee!.dob;
      _salaryController.text = widget.employee!.salary.toString();
      _imageUrl = widget.employee!.image;
    }
  }

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveEmployee() async{
    if(_formkey.currentState!.validate()){
      final employee = OnlineEmployee(
        id: widget.employee?.id,
        name: _nameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
