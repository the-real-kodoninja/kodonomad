import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/listing_provider.dart';
import '../widgets/listing_card.dart';

class MarketplaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final listings = ref.watch(listingProvider);
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final listing = listings[index];
            return ListingCard(listing: listing).animate().scale(duration: 200.ms);
          },
        );
      },
    );
  }
}
