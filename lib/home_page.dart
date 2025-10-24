
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shake/shake.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _emergencyContact;
  late ShakeDetector _shakeDetector;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    if (!kIsWeb) {
      _shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: () {
          // It's safer to handle UI logic after the current frame is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isSending) {
              _handleShake();
            }
          });
        },
        minimumShakeCount: 2,
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        shakeThresholdGravity: 2.7,
      );
    }
  }

  Future<void> _requestPermissions() async {
    if (!kIsWeb) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _handleShake() async {
    if (!mounted) return;
    setState(() {
      _isSending = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shake detected! Preparing emergency message...'),
        backgroundColor: Colors.orange,
      ),
    );

    try {
      if (_emergencyContact == null || _emergencyContact!.isEmpty) {
        await _showEmergencyContactDialog();
      } else {
        await _triggerEmergencyMessage(_emergencyContact!);
      }
    } finally {
      // Keep the sending state for a bit longer so the user sees the message
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _triggerEmergencyMessage(String contact) async {
    try {
      final position = await _getCurrentPosition();
      String message;
      if (position != null) {
        message =
            'Emergency! I need help. My current location is: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      } else {
        message = 'Emergency! I need help. My location is not available.';
      }
      await _sendSms(message, [contact]);
    } catch (e) {
      developer.log('Error preparing emergency message: $e', name: 'HomePage');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error preparing message: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Position?> _getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location services are disabled. Please enable them in your settings.',
            ),
          ),
        );
        return null;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are permanently denied. Please enable them in your settings.',
            ),
          ),
        );
        return null;
      }
      // CORRECTED: `getCurrentPosition` in the new version doesn't take desiredAccuracy.
      // It uses the best available accuracy by default.
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      developer.log('Error getting location: $e', name: 'HomePage');
      return null;
    }
  }

  // REWRITTEN: This function now uses `url_launcher` to open the default SMS app.
  Future<void> _sendSms(String message, List<String> recipients) async {
    if (kIsWeb) {
      const warning = 'SMS functionality is not available on web.';
      developer.log(warning, name: 'HomePage.sendSms');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(warning), backgroundColor: Colors.orange),
      );
      return;
    }

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: recipients.join(','), // Allows sending to multiple recipients
      queryParameters: <String, String>{
        'body': message,
      },
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening SMS app to send emergency message...'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw 'Could not launch SMS app.';
      }
    } catch (e) {
      developer.log('SMS Error: $e', name: 'HomePage.sendSms');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open SMS app: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showEmergencyContactDialog() async {
    final contact = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? contactInput;
        final formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: const Text('Set Emergency Contact'),
          content: Form(
            key: formKey,
            child: TextFormField(
              onChanged: (value) {
                contactInput = value;
              },
              decoration: const InputDecoration(
                hintText: "Enter phone number",
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                // Simple validation for a phone number
                if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(contactInput);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (contact != null && contact.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _emergencyContact = contact;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Emergency contact set to $contact'),
          backgroundColor: Colors.blue,
        ),
      );
      // If the shake was triggered before setting a contact, now send the message.
      if (_isSending) {
        await _triggerEmergencyMessage(contact);
      }
    } else {
       if (mounted && _isSending) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _shakeDetector.stopListening();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Assuming you have a login route at '/'
              context.go('/');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sos,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),
              const Text(
                'Shake for Emergency',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                kIsWeb
                    ? 'The emergency shake feature is not available on the web.'
                    : 'In an emergency, shake your phone twice. We will open your SMS app with a pre-filled message and your location.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (_emergencyContact != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Current Contact: $_emergencyContact',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ElevatedButton.icon(
                icon: const Icon(Icons.contact_phone_outlined),
                onPressed: _showEmergencyContactDialog,
                label: Text(
                  _emergencyContact == null
                      ? 'Set Emergency Contact'
                      : 'Change Emergency Contact',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
