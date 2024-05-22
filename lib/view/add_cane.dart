import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iseeapp2/Database/DatabaseCane.dart';

class AddCane extends StatefulWidget {
  const AddCane({super.key});

  @override
  State<AddCane> createState() => _AddCaneState();
}

class _AddCaneState extends State<AddCane> {


  final _formKey = GlobalKey<FormState>(); // Create a form key for validation
  String ipServer = ''; // Initialize ipServer to an empty string
  String nickname = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Positioned(
                left: 26,
                top: 190, // Adjust position as needed
                child: Form(
                  key: _formKey, // Apply form key for validation
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black), // Black border
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 17),
                              child: Icon(Icons.person), // User icon
                            ),
                            SizedBox(width: 10), // Spacing between icon and text
                            Expanded(
                              child: Center(
                                child: TextFormField(
                                  style: TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    hintText: 'IP Server', // Hint text
                                    hintStyle: TextStyle(color: Colors.grey), // Gray hint
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                  ),
                                  validator: (value) {
                                    // Add validation logic if needed
                                    // For example, check for valid IP format
                                    return null; // Or return an error message
                                  },
                                  onChanged: (value) {
                                    ipServer = value; // Update ipServer when text changes
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 50),
                      Container(
                        width: 300,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black), // Black border
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 17),
                              child: Icon(Icons.person), // User icon
                            ),
                            SizedBox(width: 10), // Spacing between icon and text
                            Expanded(
                              child: Center(
                                child: TextFormField(
                                  style: TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    hintText: 'Nickname', // Hint text
                                    hintStyle: TextStyle(color: Colors.grey), // Gray hint
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                  ),
                                  validator: (value) {
                                    // Add validation logic if needed
                                    // For example, check for valid IP format
                                    return null; // Or return an error message
                                  },
                                  onChanged: (value) {
                                    nickname = value; // Update ipServer when text changes
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 50),

                      Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, proceed with adding Cane
                              handleAddCane();
                            } else {
                              // Show a snackbar or other error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter a valid IP server'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0D5E37), // Green background
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            'Thêm',
                            style: TextStyle(
                              color: Colors.white, // White text
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleAddCane() {
    final databaseHelper = DatabaseCane();
    if(ipServer == '' || nickname == ''){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.pink,
          content: Text('Hãy nhập đủ nội dung'),
        ),
      );
    }
    else{
      databaseHelper.addCane(ipServer, nickname);
      print(ipServer);
      print(nickname);
    }
  }
}
