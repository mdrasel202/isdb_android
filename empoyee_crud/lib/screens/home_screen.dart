import 'package:flutter/material.dart';
import 'package:empoyee_crud/screens/employee_screen.dart';
import 'package:empoyee_crud/screens/employee_screens.dart';
import 'package:empoyee_crud/screens/student_screen.dart';
import 'package:empoyee_crud/screens/circle_screen.dart';
import 'package:empoyee_crud/screens/api_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
               color: Colors.blue,
              ),
                child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Employee'),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmployeeScreen(),
                 ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEmployeeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt                                                                                              ),
              title: const Text('Student'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to Employee App'),
      ),
    );
  }
}
