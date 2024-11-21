import 'package:flutter/material.dart';
import 'package:login/view_model/visibility_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blank_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  void _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('phone number') ?? '';
    _passwordController.text = prefs.getString('password') ?? '';
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('phone number', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('phone number');
      await prefs.remove('password');
      await prefs.remove('rememberMe');
    }
  }

  void _onSubmit() {
    _saveCredentials();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BlankPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordVisibilityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'phone number'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: passwordProvider.isObscured,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordProvider.isObscured
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: passwordProvider.toggleVisibility,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('Remember Me'),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
