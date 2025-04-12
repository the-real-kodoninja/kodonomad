import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// DatabaseHelper class for managing SQLite operations without model dependencies
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Get or initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'kodonomad.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create database tables
  Future<void> _createDB(Database db, int version) async {
    // Profiles table
    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        bio TEXT,
        nomadType TEXT,
        photoUrl TEXT,
        milesTraveled INTEGER
      )
    ''');

    // Posts table
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profileId INTEGER,
        content TEXT NOT NULL,
        imageUrl TEXT,
        timestamp TEXT NOT NULL,
        likes INTEGER DEFAULT 0,
        shares INTEGER DEFAULT 0,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      )
    ''');

    // Comments table
    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postId INTEGER,
        profileId INTEGER,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (postId) REFERENCES posts(id) ON DELETE CASCADE,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      )
    ''');

    // Replies table
    await db.execute('''
      CREATE TABLE replies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        commentId INTEGER,
        profileId INTEGER,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (commentId) REFERENCES comments(id) ON DELETE CASCADE,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      )
    ''');

    // Likes table
    await db.execute('''
      CREATE TABLE likes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postId INTEGER,
        profileId INTEGER,
        FOREIGN KEY (postId) REFERENCES posts(id) ON DELETE CASCADE,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      )
    ''');

    // Shares table
    await db.execute('''
      CREATE TABLE shares (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postId INTEGER,
        profileId INTEGER,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (postId) REFERENCES posts(id) ON DELETE CASCADE,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      )
    ''');

    // Messages table
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        senderId INTEGER,
        receiverId INTEGER,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        isRead INTEGER DEFAULT 0,
        FOREIGN KEY (senderId) REFERENCES profiles(id) ON DELETE CASCADE,
        FOREIGN KEY (receiverId) REFERENCES profiles(id) ON DELETE CASCADE
      )
    ''');

    // Spots table (adjusted to match schema from first snippet)
    await db.execute('''
      CREATE TABLE spots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        type TEXT NOT NULL,
        rating REAL
      )
    ''');

    // Listings table
    await db.execute('''
      CREATE TABLE listings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profileId INTEGER,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('''
    CREATE TABLE forum_posts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      profileId INTEGER,
      title TEXT,
      content TEXT,
      timestamp TEXT,
      upvotes INTEGER,
      downvotes INTEGER,
      FOREIGN KEY (profileId) REFERENCES profiles(id)
    )
    ''');
    
    await db.execute('''
    CREATE TABLE followers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      followerId INTEGER,
      followingId INTEGER,
      FOREIGN KEY (followerId) REFERENCES profiles(id),
      FOREIGN KEY (followingId) REFERENCES profiles(id)
    )
    ''');
    await db.execute('''
    CREATE TABLE notifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      profileId INTEGER,
      type TEXT,
      content TEXT,
      timestamp TEXT,
      isRead INTEGER DEFAULT 0,
      FOREIGN KEY (profileId) REFERENCES profiles(id)
    )
    ''');
    
    await db.execute('''
    CREATE TABLE badges (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      profileId INTEGER,
      name TEXT,
      earnedDate TEXT,
      FOREIGN KEY (profileId) REFERENCES profiles(id)
    )
    ''');
  }

  // Generic CRUD methods using Map<String, dynamic>

  // Posts CRUD
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> post) async {
    final db = await database;
    final id = await db.insert('posts', post);
    return {...post, 'id': id};
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await database;
    return await db.query('posts', orderBy: 'timestamp DESC');
  }

  Future<void> updatePost(Map<String, dynamic> post) async {
    final db = await database;
    await db.update(
      'posts',
      post,
      where: 'id = ?',
      whereArgs: [post['id']],
    );
  }

  Future<void> deletePost(int id) async {
    final db = await database;
    await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  // Spots CRUD
  Future<Map<String, dynamic>> createSpot(Map<String, dynamic> spot) async {
    final db = await database;
    final id = await db.insert('spots', spot);
    return {...spot, 'id': id};
  }

  Future<List<Map<String, dynamic>>> getSpots() async {
    final db = await database;
    return await db.query('spots');
  }

  Future<void> updateSpot(Map<String, dynamic> spot) async {
    final db = await database;
    await db.update(
      'spots',
      spot,
      where: 'id = ?',
      whereArgs: [spot['id']],
    );
  }

  Future<void> deleteSpot(int id) async {
    final db = await database;
    await db.delete('spots', where: 'id = ?', whereArgs: [id]);
  }

  // Listings CRUD
  Future<Map<String, dynamic>> createListing(Map<String, dynamic> listing) async {
    final db = await database;
    final id = await db.insert('listings', listing);
    return {...listing, 'id': id};
  }

  Future<List<Map<String, dynamic>>> getListings() async {
    final db = await database;
    return await db.query('listings');
  }

  Future<void> updateListing(Map<String, dynamic> listing) async {
    final db = await database;
    await db.update(
      'listings',
      listing,
      where: 'id = ?',
      whereArgs: [listing['id']],
    );
  }

  Future<void> deleteListing(int id) async {
    final db = await database;
    await db.delete('listings', where: 'id = ?', whereArgs: [id]);
  }

  // Comments CRUD
  Future<Map<String, dynamic>> createComment(Map<String, dynamic> comment) async {
    final db = await database;
    final id = await db.insert('comments', comment);
    return {...comment, 'id': id};
  }

  Future<List<Map<String, dynamic>>> getComments(int postId) async {
    final db = await database;
    return await db.query(
      'comments',
      where: 'postId = ?',
      whereArgs: [postId],
      orderBy: 'timestamp ASC',
    );
  }

  // Replies CRUD
  Future<Map<String, dynamic>> createReply(Map<String, dynamic> reply) async {
    final db = await database;
    final id = await db.insert('replies', reply);
    return {...reply, 'id': id};
  }

  Future<List<Map<String, dynamic>>> getReplies(int commentId) async {
    final db = await database;
    return await db.query(
      'replies',
      where: 'commentId = ?',
      whereArgs: [commentId],
      orderBy: 'timestamp ASC',
    );
  }

  // Likes CRUD
  Future<void> likePost(int postId, int profileId) async {
    final db = await database;
    await db.insert('likes', {'postId': postId, 'profileId': profileId});
    await db.rawUpdate(
      'UPDATE posts SET likes = likes + 1 WHERE id = ?',
      [postId],
    );
  }

  Future<void> unlikePost(int postId, int profileId) async {
    final db = await database;
    await db.delete(
      'likes',
      where: 'postId = ? AND profileId = ?',
      whereArgs: [postId, profileId],
    );
    await db.rawUpdate(
      'UPDATE posts SET likes = likes - 1 WHERE id = ?',
      [postId],
    );
  }

  Future<bool> isLiked(int postId, int profileId) async {
    final db = await database;
    final result = await db.query(
      'likes',
      where: 'postId = ? AND profileId = ?',
      whereArgs: [postId, profileId],
    );
    return result.isNotEmpty;
  }

  // Shares CRUD
  Future<Map<String, dynamic>> sharePost(int postId, int profileId) async {
    final db = await database;
    final shareData = {
      'postId': postId,
      'profileId': profileId,
      'timestamp': DateTime.now().toIso8601String(),
    };
    final id = await db.insert('shares', shareData);
    await db.rawUpdate(
      'UPDATE posts SET shares = shares + 1 WHERE id = ?',
      [postId],
    );
    return {...shareData, 'id': id};
  }

  // Messages CRUD
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> message) async {
    final db = await database;
    final id = await db.insert('messages', message);
    return {...message, 'id': id};
  }

  Future<List<Map<String, dynamic>>> getMessages(int senderId, int receiverId) async {
    final db = await database;
    return await db.query(
      'messages',
      where: '(senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)',
      whereArgs: [senderId, receiverId, receiverId, senderId],
      orderBy: 'timestamp ASC',
    );
  }

  Future<void> markMessageRead(int messageId) async {
    final db = await database;
    await db.update(
      'messages',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }
  
  Future<Map<String, dynamic>> createForumPost(Map<String, dynamic> post) async {
    final db = await database;
    final id = await db.insert('forum_posts', post);
    return {...post, 'id': id};
  }

  Future<List<Map<String, dynamic>>> getForumPosts() async {
    final db = await database;
    return await db.query('forum_posts', orderBy: 'timestamp DESC');
  }

  Future<void> upvoteForumPost(int postId, int profileId) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE forum_posts SET upvotes = upvotes + 1 WHERE id = ?',
      [postId],
    );
  }

  Future<void> downvoteForumPost(int postId, int profileId) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE forum_posts SET downvotes = downvotes + 1 WHERE id = ?',
      [postId],
    );
  }
  
  Future<void> follow(int followerId, int followingId) async {
    final db = await database;
    await db.insert('followers', {'followerId': followerId, 'followingId': followingId});
  }

  Future<void> unfollow(int followerId, int followingId) async {
    final db = await database;
    await db.delete(
      'followers',
      where: 'followerId = ? AND followingId = ?',
      whereArgs: [followerId, followingId],
    );
  }

  Future<List<Map<String, dynamic>>> getFollowers(int profileId) async {
    final db = await database;
    return await db.query(
      'followers',
      where: 'followingId = ?',
      whereArgs: [profileId],
    );
  }

  Future<List<Map<String, dynamic>>> getFollowing(int profileId) async {
    final db = await database;
    return await db.query(
      'followers',
      where: 'followerId = ?',
      whereArgs: [profileId],
    );
  }

  Future<void> addNotification(int profileId, String type, String content) async {
    final db = await database;
    await db.insert('notifications', {
      'profileId': profileId,
      'type': type,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  Future<void> awardBadge(int profileId, String name) async {
    final db = await database;
    await db.insert('badges', {
      'profileId': profileId,
      'name': name,
      'earnedDate': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getBadges(int profileId) async {
    final db = await database;
    return await db.query('badges', where: 'profileId = ?', whereArgs: [profileId]);
  }

  // Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
