// lib/features/games/providers/nomad_quest_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kodonomad/utils/location_service.dart';
import 'package:kodonomad/utils/encryption_service.dart';

class NomadStop {
  final int id;
  final String name;
  final String encryptedLocation;
  final String description;
  final String triviaQuestion;
  final String triviaAnswer;
  final int artifactId;
  final int radius;

  NomadStop({
    required this.id,
    required this.name,
    required this.encryptedLocation,
    required this.description,
    required this.triviaQuestion,
    required this.triviaAnswer,
    required this.artifactId,
    required this.radius,
  });

  factory NomadStop.fromMap(Map<String, dynamic> map) => NomadStop(
        id: map['id'],
        name: map['name'],
        encryptedLocation: map['encrypted_location'],
        description: map['description'],
        triviaQuestion: map['trivia_question'],
        triviaAnswer: map['trivia_answer'],
        artifactId: map['artifact_id'],
        radius: map['radius'],
      );
}

class Artifact {
  final int id;
  final String name;
  final String description;
  final String icon;

  Artifact({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  factory Artifact.fromMap(Map<String, dynamic> map) => Artifact(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        icon: map['icon'],
      );
}

class NomadQuestNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref _ref;
  final _supabase = Supabase.instance.client;

  NomadQuestNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      state = const AsyncValue.loading();
      final myId = 1;

      // Fetch nomad stops
      final stopsData = await _supabase.from('nomad_stops').select('*, artifacts(*)');
      final stops = stopsData.map((map) => NomadStop.fromMap(map)).toList();

      // Fetch artifacts
      final artifactsData = await _supabase.from('artifacts').select();
      final artifacts = artifactsData.map((map) => Artifact.fromMap(map)).toList();

      // Fetch player's collection
      final collectionData = await _supabase
          .from('player_collections')
          .select('*, artifacts(*)')
          .eq('profile_id', myId);
      final collection = collectionData.map((map) => Artifact.fromMap(map['artifacts'])).toList();

      state = AsyncValue.data({
        'stops': stops,
        'artifacts': artifacts,
        'collection': collection,
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Check if user is within a nomad stop's radius
  Future<bool> checkProximity(NomadStop stop) async {
    final locationData = await LocationService.getCurrentLocation();
    final stopLocation = EncryptionService.decryptLocation(stop.encryptedLocation);
    final distance = Geolocator.distanceBetween(
      locationData['latitude'],
      locationData['longitude'],
      stopLocation[0],
      stopLocation[1],
    );
    return distance <= stop.radius;
  }

  // Collect an artifact
  Future<void> collectArtifact(int stopId, int artifactId) async {
    final myId = 1;
    await _supabase.from('player_collections').insert({
      'profile_id': myId,
      'artifact_id': artifactId,
    });
    await _supabase.from('profiles').update({
      'points': _supabase.raw('points + 50'), // Award 50 points for collecting an artifact
    }).eq('id', myId);
    await fetchData();
  }
}

final nomadQuestProvider = StateNotifierProvider<NomadQuestNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return NomadQuestNotifier(ref);
});
