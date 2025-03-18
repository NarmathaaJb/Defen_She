import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback? onPressed;
  const SignupPage({super.key, required this.onPressed});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isPasswordVisible = false;
  int _currentStep = 0;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _city = TextEditingController();

  final TextEditingController _emergencyName1 = TextEditingController();
  final TextEditingController _emergencyNumber1 = TextEditingController();
  final TextEditingController _emergencyName2 = TextEditingController();
  final TextEditingController _emergencyNumber2 = TextEditingController();
  final TextEditingController _emergencyName3 = TextEditingController();
  final TextEditingController _emergencyNumber3 = TextEditingController();

  String _gender = 'Female';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _dob.dispose();
    _address.dispose();
    _city.dispose();
    _emergencyName1.dispose();
    _emergencyNumber1.dispose();
    _emergencyName2.dispose();
    _emergencyNumber2.dispose();
    _emergencyName3.dispose();
    _emergencyNumber3.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );

      await userCredential.user!.updateDisplayName(_name.text.trim());
      await userCredential.user!.reload();

      List<Map<String, dynamic>> emergencyContacts = [];
      if (_emergencyName1.text.isNotEmpty && _emergencyNumber1.text.isNotEmpty) {
        emergencyContacts.add({
          'name': _emergencyName1.text.trim(),
          'number': _emergencyNumber1.text.trim(),
        });
      }
      if (_emergencyName2.text.isNotEmpty && _emergencyNumber2.text.isNotEmpty) {
        emergencyContacts.add({
          'name': _emergencyName2.text.trim(),
          'number': _emergencyNumber2.text.trim(),
        });
      }
      if (_emergencyName3.text.isNotEmpty && _emergencyNumber3.text.isNotEmpty) {
        emergencyContacts.add({
          'name': _emergencyName3.text.trim(),
          'number': _emergencyNumber3.text.trim(),
        });
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'gender': _gender,
        'dob': _dob.text.trim(),
        'address': _address.text.trim(),
        'city': _city.text.trim(),
        'emergencyContacts': emergencyContacts,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup Successful!")),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Signup failed!";
      if (e.code == 'weak-password') {
        errorMessage = "Password is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Email is already in use.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAD1457), Color(0xFFF48FB1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: _currentStep == 0 ? _buildFirstStep() : _buildSecondStep(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 180,
          color: Colors.white,
        ),
        const SizedBox(height: 20),
        _buildTextField(_name, "Name"),
        _buildTextField(_email, "Email", TextInputType.emailAddress),
        _buildTextField(_password, "Password", TextInputType.visiblePassword, true),
        _buildDropdownField(),
        _buildTextField(_dob, "Date of Birth (DD/MM/YYYY)", TextInputType.datetime),
        _buildTextField(_address, "Address"),
        _buildTextField(_city, "City"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _currentStep = 1;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text("Next"),
        ),
      ],
    );
  }

  Widget _buildSecondStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Emergency Contacts (Optional)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        _buildTextField(_emergencyName1, "Emergency Contact 1 Name"),
        _buildTextField(_emergencyNumber1, "Emergency Contact 1 Number", TextInputType.phone),
        _buildTextField(_emergencyName2, "Emergency Contact 2 Name"),
        _buildTextField(_emergencyNumber2, "Emergency Contact 2 Number", TextInputType.phone),
        _buildTextField(_emergencyName3, "Emergency Contact 3 Name"),
        _buildTextField(_emergencyNumber3, "Emergency Contact 3 Number", TextInputType.phone),
        const SizedBox(height: 20),
        _buildSignupButton(),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            setState(() {
              _currentStep = 0;
            });
          },
          child: const Text("Back"),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: widget.onPressed,
          child: const Text("Already have an account? Login"),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      [TextInputType keyboardType = TextInputType.text, bool isPassword = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (hintText.contains("Emergency") && value!.isEmpty) {
            return null;
          }
          if (value == null || value.isEmpty) {
            return 'Enter your $hintText';
          }
          if (hintText == "Email" &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Enter a valid email';
          }
          if (hintText == "Date of Birth (DD/MM/YYYY)" &&
              !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
            return 'Enter date in DD/MM/YYYY format';
          }
          return null;
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.edit, color: Colors.white70),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: _gender,
        dropdownColor: Colors.pink[200],
        onChanged: (value) {
          setState(() {
            _gender = value!;
          });
        },
        items: ['Male', 'Female', 'Other'].map((gender) {
          return DropdownMenuItem(value: gender, child: Text(gender));
        }).toList(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          labelText: "Gender",
          labelStyle: const TextStyle(color: Colors.white60),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : createUserWithEmailAndPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.pinkAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.pinkAccent)
            : const Text("Sign Up"),
      ),
    );
  }
}