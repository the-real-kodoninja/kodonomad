// lib/features/checkins/screens/checkin_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/checkins/providers/checkin_provider.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen();

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _locationController = TextEditingController();
  bool _autoCheckInEnabled = false;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkInData = ref.watch(checkInProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Check-Ins')),
      body: checkInData.when(
        data: (data) {
          final checkIns = data['checkIns'] as List<CheckIn>;
          final earnedBadges = data['earnedBadges'] as List<Badge>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Manual Check-In
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location Name'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_locationController.text.isNotEmpty) {
                      ref.read(checkInProvider.notifier).checkIn(_locationController.text);
                      _locationController.clear();
                    }
                  },
                  child: const Text('Check In'),
                ),
                const SizedBox(height: 16),

                // Automatic Check-In Toggle
                SwitchListTile(
                  title: const Text('Enable Automatic Check-Ins'),
                  value: _autoCheckInEnabled,
                  onChanged: (value) {
                    setState(() {
                      _autoCheckInEnabled = value;
                      if (value) {
                        // Start listening for location changes
                        Geolocator.getPositionStream().listen((position) {
                          ref.read(checkInProvider.notifier).autoCheckIn();
                        });
                      }
                    });
                  },
                ),

                // Check-In History
                const SizedBox(height: 16),
                const Text('Check-In History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...checkIns.map((checkIn) => ListTile(
                      title: Text(checkIn.locationName),
                      subtitle: Text(checkIn.timestamp.toString()),
                      trailing: checkIn.isAutomatic ? const Text('Auto') : null,
                    )),

                // Earned Badges
                const SizedBox(height: 16),
                const Text('Earned Badges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...earnedBadges.map((badge) => ListTile(
                      leading: Text(badge.icon),
                      title: Text(badge.name),
                      subtitle: Text(badge.description),
                    )),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
