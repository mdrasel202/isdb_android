// import '../enum/role.dart';
//
// class UserResponse {enum Role {
// USER,
// ADMIN,
// }
//
// rn {
// 'email': email,
// 'password': password,
// };
// }
// }
//
// class UserResponse {
//   final int id;
//   final String email;
//   final Role role;
//   final String firstName;
//   final String lastName;
//   final String? phone; // Phone can be null in UserResponse
//
//   UserResponse({
//     required this.id,
//     required this.email,
//     required this.role,
//     required this.firstName,
//     required this.lastName,
//     this.phone,
//   });
//
//   factory UserResponse.fromJson(Map<String, dynamic> json) {
//     return UserResponse(
//       id: json['id'],
//       email: json['email'],
//       role: Role.values
//           .firstWhere((e) => e.toString().split('.').last == json['role']),
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       phone: json['phone'],
//     );
//   }
// }
//   final int id;
//   final String email;
//   final Role role;
//   final String firstName;
//   final String lastName;
//   final String? phone; // Phone can be null in UserResponse
//
//   UserResponse({
//     required this.id,
//     required this.email,
//     required this.role,
//     required this.firstName,
//     required this.lastName,
//     this.phone,
//   });
//
//   factory UserResponse.fromJson(Map<String, dynamic> json) {
//     return UserResponse(
//       id: json['id'],
//       email: json['email'],
//       role: Role.values
//           .firstWhere((e) => e.toString().split('.').last == json['role']),
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       phone: json['phone'],
//     );
//   }
// }
