class Profile {
  final int id;
  final String username;
  final int milesTraveled;
  final int? campingNights;
  final int? stealthCampingNights;
  final int? noKnockCount;
  final int? urbanSleepingNights;
  final int? wildernessSleepingNights;
  final int? stargazingNights;
  final int? peaksClimbed;
  final int? kayakingMiles;
  final int? fishCaught;
  final int? plantsForaged;
  final int? followers;
  final int? storiesPosted;
  final int? cleanups;
  final int? toursLed;
  final int? forumPosts;
  final int? itemsSold;
  final int? stickersSold;
  final int? tradesCompleted;
  final int? reviewsWritten;
  final int? sponsorships;
  final int? locationsVisited;
  final int? bordersCrossed;
  final int? trailsDiscovered;
  final bool isVerified;
  final String? flairIcon;
  final String? location;
  final int points;

  Profile({
    required this.id,
    required this.username,
    required this.milesTraveled,
    this.campingNights,
    this.stealthCampingNights,
    this.noKnockCount,
    this.urbanSleepingNights,
    this.wildernessSleepingNights,
    this.stargazingNights,
    this.peaksClimbed,
    this.kayakingMiles,
    this.fishCaught,
    this.plantsForaged,
    this.followers,
    this.storiesPosted,
    this.cleanups,
    this.toursLed,
    this.forumPosts,
    this.itemsSold,
    this.stickersSold,
    this.tradesCompleted,
    this.reviewsWritten,
    this.sponsorships,
    this.locationsVisited,
    this.bordersCrossed,
    this.trailsDiscovered,
    this.isVerified = false,
    this.flairIcon,
    this.location,
    this.points = 0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'miles_traveled': milesTraveled,
        'camping_nights': campingNights,
        'stealth_camping_nights': stealthCampingNights,
        'no_knock_count': noKnockCount,
        'urban_sleeping_nights': urbanSleepingNights,
        'wilderness_sleeping_nights': wildernessSleepingNights,
        'stargazing_nights': stargazingNights,
        'peaks_climbed': peaksClimbed,
        'kayaking_miles': kayakingMiles,
        'fish_caught': fishCaught,
        'plants_foraged': plantsForaged,
        'followers': followers,
        'stories_posted': storiesPosted,
        'cleanups': cleanups,
        'tours_led': toursLed,
        'forum_posts': forumPosts,
        'items_sold': itemsSold,
        'stickers_sold': stickersSold,
        'trades_completed': tradesCompleted,
        'reviews_written': reviewsWritten,
        'sponsorships': sponsorships,
        'locations_visited': locationsVisited,
        'borders_crossed': bordersCrossed,
        'trails_discovered': trailsDiscovered,
        'is_verified': isVerified,
        'flair_icon': flairIcon,
      };

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
        id: map['id'],
        username: map['username'],
        milesTraveled: map['miles_traveled'],
        campingNights: map['camping_nights'],
        stealthCampingNights: map['stealth_camping_nights'],
        noKnockCount: map['no_knock_count'],
        urbanSleepingNights: map['urban_sleeping_nights'],
        wildernessSleepingNights: map['wilderness_sleeping_nights'],
        stargazingNights: map['stargazing_nights'],
        peaksClimbed: map['peaks_climbed'],
        kayakingMiles: map['kayaking_miles'],
        fishCaught: map['fish_caught'],
        plantsForaged: map['plants_foraged'],
        followers: map['followers'],
        storiesPosted: map['stories_posted'],
        cleanups: map['cleanups'],
        toursLed: map['tours_led'],
        forumPosts: map['forum_posts'],
        itemsSold: map['items_sold'],
        stickersSold: map['stickers_sold'],
        tradesCompleted: map['trades_completed'],
        reviewsWritten: map['reviews_written'],
        sponsorships: map['sponsorships'],
        locationsVisited: map['locations_visited'],
        bordersCrossed: map['borders_crossed'],
        trailsDiscovered: map['trails_discovered'],
        isVerified: map['is_verified'] ?? false,
        flairIcon: map['flair_icon'],
	location: map['location'],
	points: map['points'] ?? 0,
      );

  Profile copyWithDynamic(String field, dynamic value) {
    return Profile(
      id: id,
      username: username,
      milesTraveled: field == 'miles_traveled' ? value : milesTraveled,
      campingNights: field == 'camping_nights' ? value : campingNights,
      stealthCampingNights: field == 'stealth_camping_nights' ? value : stealthCampingNights,
      noKnockCount: field == 'no_knock_count' ? value : noKnockCount,
      urbanSleepingNights: field == 'urban_sleeping_nights' ? value : urbanSleepingNights,
      wildernessSleepingNights: field == 'wilderness_sleeping_nights' ? value : wildernessSleepingNights,
      stargazingNights: field == 'stargazing_nights' ? value : stargazingNights,
      peaksClimbed: field == 'peaks_climbed' ? value : peaksClimbed,
      kayakingMiles: field == 'kayaking_miles' ? value : kayakingMiles,
      fishCaught: field == 'fish_caught' ? value : fishCaught,
      plantsForaged: field == 'plants_foraged' ? value : plantsForaged,
      followers: field == 'followers' ? value : followers,
      storiesPosted: field == 'stories_posted' ? value : storiesPosted,
      cleanups: field == 'cleanups' ? value : cleanups,
      toursLed: field == 'tours_led' ? value : toursLed,
      forumPosts: field == 'forum_posts' ? value : forumPosts,
      itemsSold: field == 'items_sold' ? value : itemsSold,
      stickersSold: field == 'stickers_sold' ? value : stickersSold,
      tradesCompleted: field == 'trades_completed' ? value : tradesCompleted,
      reviewsWritten: field == 'reviews_written' ? value : reviewsWritten,
      sponsorships: field == 'sponsorships' ? value : sponsorships,
      locationsVisited: field == 'locations_visited' ? value : locationsVisited,
      bordersCrossed: field == 'borders_crossed' ? value : bordersCrossed,
      trailsDiscovered: field == 'trails_discovered' ? value : trailsDiscovered,
      isVerified: field == 'is_verified' ? value : isVerified,
      flairIcon: field == 'flair_icon' ? value : flairIcon,
    );
  }
}
