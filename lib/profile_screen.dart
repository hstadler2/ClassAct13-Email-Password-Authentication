import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

// ProfileScreen displays the current user's email and allows password change and logout.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _passwordController = TextEditingController();

  // Show a dialog to change the password.
  void _changePassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password (6+ characters)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_passwordController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Password must be at least 6 characters'),
                  ));
                  return;
                }
                bool result =
                    await AuthService.changePassword(_passwordController.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(result
                      ? 'Password changed successfully'
                      : 'Failed to change password'),
                ));
                _passwordController.clear();
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _passwordController.clear();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Sign out using AuthService.
  void _signOut() async {
    await AuthService.signOut();
    // The AuthWrapper will update the UI automatically.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the logged-in user's email.
            Text('Logged in as: ${user?.email ?? "No Email"}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
