import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/database_helper.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DatabaseHelper();
  late Future<User?> _userFuture;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userFuture = dbHelper.getUserById(int.parse(widget.userId));
    _userFuture.then((user) {
      if (user != null) {
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _middleNameController.text = user.middleName ?? '';
        _phoneNumberController.text = user.phoneNumber;
        _emailController.text = user.email;
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _genderController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logout() {
    context.go('/');
  }

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        id: int.parse(widget.userId),
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        middleName: _middleNameController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : (await _userFuture)!.password,
      );

      await dbHelper.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found.'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First Name', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _firstNameController,
                        validator: (value) => value!.isEmpty ? 'Enter a first name' : null,
                      ),
                      const SizedBox(height: 16),
                      Text('Last Name', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _lastNameController,
                        validator: (value) => value!.isEmpty ? 'Enter a last name' : null,
                      ),
                      const SizedBox(height: 16),
                      Text('Middle Name', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _middleNameController,
                      ),
                      const SizedBox(height: 16),
                      Text('Gender', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _genderController,
                        validator: (value) => value!.isEmpty ? 'Enter a gender' : null,
                      ),
                      const SizedBox(height: 16),
                      Text('Phone Number', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _phoneNumberController,
                        validator: (value) => value!.isEmpty ? 'Enter a phone number' : null,
                      ),
                      const SizedBox(height: 16),
                      Text('Email', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                      ),
                      const SizedBox(height: 16),
                      Text('New Password', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _updateUser,
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
