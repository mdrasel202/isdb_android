// import '../enum/role.dart';
//
// class RegisterRequest {
//   final String email;
//   final String password;
//   final Role role;
//   final String firstName;
//   final String lastName;
//   final String phone;
//
//   RegisterRequest({
//     required this.email,
//     required this.password,
//     required this.role,
//     required this.firstName,
//     required this.lastName,
//     required this.phone,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'email': email,
//       'password': password,
//       'role': role.toString().split('.').last,
//       'firstName': firstName,
//       'lastName': lastName,
//       'phone': phone,
//     };
//   }
// }