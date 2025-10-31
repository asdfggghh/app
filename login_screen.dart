import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _isRegister = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Smart Task Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          SizedBox(height: 20),
          _loading ? CircularProgressIndicator() : ElevatedButton(
            onPressed: () async {
              setState(() => _loading = true);
              try {
                if (_isRegister) {
                  await auth.register(_email.text.trim(), _pass.text.trim());
                } else {
                  await auth.signIn(_email.text.trim(), _pass.text.trim());
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
              } finally {
                setState(() => _loading = false);
              }
            },
            child: Text(_isRegister ? 'Register' : 'Login'),
          ),
          TextButton(
            onPressed: () => setState(() => _isRegister = !_isRegister),
            child: Text(_isRegister ? 'Have an account? Login' : 'Create new account')
          )
        ]),
      ),
    );
  }
}
