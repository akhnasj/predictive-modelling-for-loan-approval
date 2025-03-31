import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const LoanApprovalApp());
}

class LoanApprovalApp extends StatelessWidget {
  const LoanApprovalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Approval System',
      theme: ThemeData(
        colorScheme:
            ColorScheme.light(primary: Colors.teal, secondary: Colors.grey),
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginPage(), // Start with Login Page
    );
  }
}
