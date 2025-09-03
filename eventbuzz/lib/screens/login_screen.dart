import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool _obscureLogin = true;
  bool _obscureSignup = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('is_logged_in') ?? false;
    if (loggedIn) {
      // User already logged in, redirect to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(onThemeToggle: widget.onThemeToggle),
        ),
      );
    }
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

  Future<void> _signup() async {
    if (_signupKey.currentState!.validate()) {
      if (signupPassCtrl.text != signupConfirmCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', signupEmailCtrl.text);
      await prefs.setString('password', signupPassCtrl.text);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful! Please login.")));
      _tabController.animateTo(0);
    }
  }

  Future<void> _login() async {
    if (_loginKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('email');
      final savedPass = prefs.getString('password');

      if (loginEmailCtrl.text == savedEmail && loginPassCtrl.text == savedPass) {
        await prefs.setBool('is_logged_in', true); // Save login state
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(onThemeToggle: widget.onThemeToggle),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid email or password")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EventBuzz Login"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Login"),
            Tab(text: "Sign Up"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _loginForm(),
          _signupForm(),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _loginKey,
        child: Column(
          children: [
            TextFormField(
              controller: loginEmailCtrl,
              validator: emailValidator,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              controller: loginPassCtrl,
              validator: passValidator,
              obscureText: _obscureLogin,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(_obscureLogin ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureLogin = !_obscureLogin),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Login")),
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
            TextFormField(
              controller: signupEmailCtrl,
              validator: emailValidator,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              controller: signupPassCtrl,
              validator: passValidator,
              obscureText: _obscureSignup,
              decoration: InputDecoration(labelText: "Password"),
            ),
            TextFormField(
              controller: signupConfirmCtrl,
              validator: passValidator,
              obscureText: _obscureSignup,
              decoration: InputDecoration(labelText: "Confirm Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signup, child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
