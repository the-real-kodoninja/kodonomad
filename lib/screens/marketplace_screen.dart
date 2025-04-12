import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/listing_provider.dart';
import '../providers/cart_provider.dart';
import '../models/listing.dart';
import '../widgets/listing_card.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen();
  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  String _searchQuery = '';
  String _categoryFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final listings = ref.watch(listingProvider);
    final filteredListings = listings.where((listing) {
      final matchesSearch = listing.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _categoryFilter == 'All' || listing.category == _categoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(hintText: 'Search...'),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        actions: [
          DropdownButton<String>(
            value: _categoryFilter,
            items: ['All', 'Sticker', 'Gear', 'Organization'].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
            onChanged: (value) => setState(() => _categoryFilter = value!),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75),
        itemCount: filteredListings.length,
        itemBuilder: (context, index) {
          final listing = filteredListings[index];
          return ListingCard(
            listing: listing,
            onAddToCart: () => ref.read(cartProvider.notifier).addToCart(1, listing.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CartScreen extends ConsumerWidget {
  const CartScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final profiles = ref.watch(profileProvider);
    final myProfile = profiles.isNotEmpty ? profiles.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final listing = Listing.fromMap(item['listings']);
          return ListTile(
            leading: listing.imageUrl != null ? Image.network(listing.imageUrl!, width: 50) : const Icon(Icons.image),
            title: Text(listing.title),
            subtitle: Text('\$${listing.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart),
              onPressed: () => ref.read(cartProvider.notifier).removeFromCart(item['id']),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            if (myProfile?.stripeId == null && myProfile?.paypalId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please add payment info in settings')),
              );
              return;
            }
            // Process payment (Stripe/PayPal) and transfer to seller
            for (var item in cartItems) {
              final listing = Listing.fromMap(item['listings']);
              if (listing.isKodonomad) {
                // Kodonomad keeps 100% profit
              } else {
                // Transfer to seller via their payment method
              }
            }
          },
          child: const Text('Checkout'),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
        ),
      ),
    );
  }
}
