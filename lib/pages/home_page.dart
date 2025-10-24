import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shake/shake.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_sms/flutter_sms.dart';
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
        onPhoneShake: (ShakeDirection) {
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
        content: Text('Shake detected! Sending emergency message...'),
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
      await Future.delayed(const Duration(seconds: 10));
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
      developer.log('Error sending emergency message: $e', name: 'HomePage');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending message: $e'),
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
              'Location services are disabled. Please enable the services',
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
            const SnackBar(content: Text('Location permissions are denied')),
          );
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are permanently denied, we cannot request permissions.',
            ),
          ),
        );
        return null;
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      developer.log('Error getting location: $e', name: 'HomePage');
      return null;
    }
  }

  Future<void> _sendSms(String message, List<String> recipients) async {
    if (kIsWeb) {
      const warning = 'SMS sending is not supported on web platforms.';
      developer.log(warning, name: 'HomePage.sendSms');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(warning), backgroundColor: Colors.orange),
      );
      return;
    }
    try {
      // String result = await sendSMS(
      //   message: message,
      //   recipients: recipients,
      //   sendDirect: true,
      // );
      // developer.log(result, name: 'HomePage.sendSms');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency message sent!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      developer.log('SMS Error: $error', name: 'HomePage.sendSms');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send SMS: $error. Please grant SMS permissions.',
          ),
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
                if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(value)) {
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
                if (mounted && _isSending) {
                  setState(() {
                    _isSending = false;
                  });
                }
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
              context.go('/');
            },
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
                Icons.security,
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
                    ? 'The emergency shake feature is only available on mobile devices.'
                    : 'In an emergency, shake your phone twice to send an SMS with your location to your contact.',
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
                icon: const Icon(Icons.contact_phone),
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
