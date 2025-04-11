class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;

  const ListingCard({required this.listing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
      ),
    );
  }
}
