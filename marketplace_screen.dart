import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/listing_provider.dart';
import '../widgets/listing_card.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  @override
  Widget build(BuildContext context) {
    final listings = ref.watch(listingProvider);
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: listings.length,
        itemBuilder: (context, index) {
          final listing = listings[index];
          return ListingCard(
            listing: listing,
            onTap: () {
              // Add to cart logic here
            },
          ).animate().scale(duration: 200.ms);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new listing logic
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
