import 'package:flutter/material.dart';
import '../models/listing.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onAddToCart;

  const ListingCard({required this.listing, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          listing.imageUrl != null
              ? Image.network(listing.imageUrl!, height: 100, fit: BoxFit.cover)
              : const Icon(Icons.image, size: 100),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(listing.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('\$${listing.price}'),
          ElevatedButton(
            onPressed: onAddToCart,
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
