import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/profile.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;

  const ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: CachedNetworkImageProvider(
              profile.photoUrl.isEmpty ? 'https://via.placeholder.com/150' : profile.photoUrl),
        ),
        SizedBox(height: 8),
        Text(profile.username, style: Theme.of(context).textTheme.headlineSmall),
        Text(profile.nomadType, style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 8),
        Text(profile.bio),
      ],
    );
  }
}
