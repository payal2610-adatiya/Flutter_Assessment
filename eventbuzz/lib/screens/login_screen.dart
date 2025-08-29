import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  LoginScreen({required this.onThemeToggle});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  final loginEmailCtrl = TextEditingController();
  final loginPassCtrl = TextEditingController();
  final signupEmailCtrl = TextEditingController();
  final signupPassCtrl = TextEditingController();
  final signupConfirmCtrl = TextEditingController();

  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Invalid email";
    return null;
  }

  String? passValidator(String? value) {
    if (value == null || value.length < 6) return "Min 6 characters";
    return null;
  }

  void login() {
    if (_loginKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(onThemeToggle: widget.onThemeToggle),
        ),
      );
    }
  }

  void signup() {
    if (_signupKey.currentState!.validate()) {
      if (signupPassCtrl.text != signupConfirmCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(onThemeToggle: widget.onThemeToggle),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(bottom: TabBar(controller: _tabController, tabs: [
        Tab(text: "Login"), Tab(text: "Sign Up")
      ])),
      body: TabBarView(controller: _tabController, children: [
        _loginForm(),
        _signupForm(),
      ]),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _loginKey,
        child: Column(
          children: [
            TextFormField(controller: loginEmailCtrl, validator: emailValidator, decoration: InputDecoration(labelText: "Email")),
            TextFormField(controller: loginPassCtrl, validator: passValidator,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                )),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("Login")),
          ],
        ),
      ),
    );
  }

  Widget _signupForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _signupKey,
        child: Column(
          children: [
            TextFormField(controller: signupEmailCtrl, validator: emailValidator, decoration: InputDecoration(labelText: "Email")),
            TextFormField(controller: signupPassCtrl, validator: passValidator, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            TextFormField(controller: signupConfirmCtrl, validator: passValidator, obscureText: true, decoration: InputDecoration(labelText: "Confirm Password")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: signup, child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
