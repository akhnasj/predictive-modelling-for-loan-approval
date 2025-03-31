import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      home: const LoanPage(),
    );
  }
}

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  _LoanFormPageState createState() => _LoanFormPageState();
}

class _LoanFormPageState extends State<LoanPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController creditScoreController = TextEditingController();
  final TextEditingController monthsEmployedController =
      TextEditingController();
  final TextEditingController numCreditLinesController =
      TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController loanTermController = TextEditingController();

  String education = "Bachelor's";
  String employmentType = "Full-time";
  String maritalStatus = "Single";
  String hasMortgage = "No";
  String hasDependents = "No";
  String loanPurpose = "Home";
  String hasCoSigner = "No";
  String defaultStatus = "No";
  String resultMessage = "";

  Future<void> checkLoanApproval() async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.47.104:8000/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Age": int.parse(ageController.text),
          "Income": int.parse(incomeController.text),
          "LoanAmount": int.parse(loanAmountController.text),
          "CreditScore": int.parse(creditScoreController.text),
          "MonthsEmployed": int.parse(monthsEmployedController.text),
          "NumCreditLines": int.parse(numCreditLinesController.text),
          "InterestRate": double.parse(interestRateController.text),
          "LoanTerm": int.parse(loanTermController.text),
          "Education": education,
          "EmploymentType": employmentType,
          "MaritalStatus": maritalStatus,
          "HasMortgage": hasMortgage,
          "HasDependents": hasDependents,
          "LoanPurpose": loanPurpose,
          "HasCoSigner": hasCoSigner,
          "Default": defaultStatus
        }),
      );

      final data = jsonDecode(response.body);
      setState(() {
        resultMessage = data["loan_approval"];
      });
    } catch (e) {
      setState(() {
        resultMessage = "Error: Unable to fetch data";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Approval Form"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(ageController, "Age"),
            _buildTextField(incomeController, "Income"),
            _buildTextField(loanAmountController, "Loan Amount"),
            _buildTextField(creditScoreController, "Credit Score"),
            _buildTextField(monthsEmployedController, "Months Employed"),
            _buildTextField(numCreditLinesController, "Number of Credit Lines"),
            _buildTextField(interestRateController, "Interest Rate"),
            _buildTextField(loanTermController, "Loan Term"),
            _buildDropdown(
                "Education", ["Bachelor's", "High School", "Master's", "PhD"],
                (value) {
              setState(() {
                education = value!;
              });
            }),
            _buildDropdown("Employment Type", [
              "Full-time",
              "Part-time",
              "Self-employed",
              "Unemployed"
            ], (value) {
              setState(() {
                employmentType = value!;
              });
            }),
            _buildDropdown("Marital Status", ["Single", "Married", "Divorced"],
                (value) {
              setState(() {
                maritalStatus = value!;
              });
            }),
            _buildDropdown("Has Mortgage", ["Yes", "No"], (value) {
              setState(() {
                hasMortgage = value!;
              });
            }),
            _buildDropdown("Loan Purpose",
                ["Home", "Auto", "Education", "Business", "Other"], (value) {
              setState(() {
                loanPurpose = value!;
              });
            }),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: checkLoanApproval,
              backgroundColor: Colors.teal,
              child: const Icon(Icons.check, size: 30),
            ),
            const SizedBox(height: 20),
            Text(resultMessage,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, List<String> options, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        value: options[0],
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
