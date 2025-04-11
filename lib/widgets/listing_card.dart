import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/listing.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;

  const ListingCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          listing.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: listing.imageUrl!,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 100,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Icon(Icons.image, size: 50),
                ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.title, style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 4),
                Text('\$${listing.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
