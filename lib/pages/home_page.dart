import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shake/shake.dart';
import 'package:myapp/components/curved_btn.dart';
import 'package:myapp/components/signup_btn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ShakeDetector detector;
  String? _emergencyContact;

  bool _isInfoVisible = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    detector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent) {
        if (mounted && _emergencyContact != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'SOS Alert Triggered! Sending alert to $_emergencyContact',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  // ADDING EMERGENCY CONTACT (FIRST TIME)
  Future<void> _showAddContactDialog() async {
    final TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Emergency Contact'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: "Enter phone number"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _emergencyContact = controller.text;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Emergency contact saved!")),
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // CHANGE EMERGENCY CONTACT
  Future<void> _changeContactDialog() async {
    final TextEditingController controller = TextEditingController(
      text: _emergencyContact,
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Emergency Contact'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: "Enter new phone number",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _emergencyContact = controller.text;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Emergency contact updated!")),
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(0.3),
            child: _emergencyContact == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Please add an emergency contact to enable SOS features:',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _showAddContactDialog,
                        child: const Text('Add Emergency Contact'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 130),

                      const Text(
                        'Shake your phone to send an alert.',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Emergency Contact: $_emergencyContact',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 50),

                      Column(
                        children: [
                          // SOS BUTTON
                          Container(
                            width: 220,
                            height: 220,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "SOS Triggered! Sending alert to $_emergencyContact",
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "SOS",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Transform.translate(
                            offset: const Offset(0, -14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CurvedButton(
                                  label: "Quick Tips",
                                  isLeft: true,
                                  onTap: () => context.go('/hotline'),
                                ),
                                const SizedBox(width: 17),
                                CurvedButton(
                                  label: "Call Hotline",
                                  isLeft: false,
                                  onTap: () => context.go('/hotline'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 17),

                      // CHANGE CONTACT BUTTON
                      GestureDetector(
                        onTap: _changeContactDialog,
                        child: Container(
                          height: 100,
                          width: 400,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.add_call, color: Colors.black87),
                                  SizedBox(width: 10),
                                  Text(
                                    "Change Emergency Contact",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
          ),
        );

      case 1:
        return Center(
          child: GestureDetector(
            onTap: () => context.go('/notification'),
            child: const Text(
              "Notification",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );

      case 2:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Profile Page',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // LOGOUT USING SIGNUP BUTTON
              SignupButton(text: "Logout", onTap: () => context.go('/login')),
            ],
          ),
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        // LOGO
        title: Image.asset("lib/images/logo2.png", height: 40),

        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              setState(() => _isInfoVisible = true);
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6A1452), Color(0xFFFFB3AE)],
              ),
            ),
            child: _buildBody(),
          ),

          // SIDEBAR
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: _isInfoVisible ? 0 : -260,
            top: 0,
            bottom: 0,
            child: Container(
              width: 260,
              color: Colors.white.withOpacity(0.95),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CLOSE BUTTON
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => context.go('/home'),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Help and Support',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.go('/demo'),
                    child: const Text(
                      "SOS Demo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => context.go('/about'),
                    child: const Text(
                      "About Us",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => context.go('/feedback'),
                    child: const Text(
                      "Feedback",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 241, 238, 240),
        selectedItemColor: const Color(0xFF6A1452),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
