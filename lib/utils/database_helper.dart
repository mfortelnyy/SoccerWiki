import 'package:mp5/models/team.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:mp5/models/user.dart';
import '../models/player.dart';



class DBHelper {
  static const String _databaseName = 's3.db';
  static const int _databaseVersion = 1;

  DBHelper._();
  static final DBHelper _singleton = DBHelper._();

  factory DBHelper() => _singleton;

  Database? _database;

  get db async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = path.join(dbDir.path, _databaseName);

    var db = await openDatabase(
      dbPath,
      version: _databaseVersion,
      readOnly: false,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT)''');

        await db.execute('''
          CREATE TABLE teams(
            team_key INTEGER PRIMARY KEY,
            team_name TEXT,
            team_logo TEXT)''');       

        await db.execute('''
          CREATE TABLE players(
            player_key INTEGER PRIMARY KEY,
            team_key INTEGER,
            player_name TEXT,
            player_image TEXT,
            player_age INTEGER,
            player_type TEXT,
            player_number INTEGER,
            player_rating INTEGER,
            FOREIGN KEY (team_key) REFERENCES teams(team_key) ON DELETE CASCADE)''');

        await db.execute('''
          CREATE TABLE user_likes_players(
            user_id INTEGER,
            player_key INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (player_key) REFERENCES players(player_key) ON DELETE CASCADE,
            PRIMARY KEY (user_id, player_key))'''); 

        await db.execute('''
          CREATE TABLE user_likes_teams(
            user_id INTEGER,
            team_key INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (team_key) REFERENCES teams(team_key) ON DELETE CASCADE,
            PRIMARY KEY (user_id, team_key))'''); 
      },
    );

    return db;
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await this.db;
    final List<Map<String, dynamic>> map = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (map.isEmpty) {
      return null; 
    }
    return User.fromMap(map.first);
  }

  Future<int> getUserId(String username) async {
    final db = await this.db;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['id'], 
      where: 'username = ?',
      whereArgs: [username]
    );
    
    if (result.isNotEmpty) {
      //print(result.first['id']);
      return result.first['id'] as int; 
    } 
    else {
      return -1; 
    }
  }

  Future<int> insertUser(User u) async {
    final db = await this.db;
    int res = await db.insert('users', u.toMap()); 
    return res;
  } 

  Future<void> insertPlayer(Player p) async{
    final db = await this.db;
    //print(p.toMap());
    await db.insert('players', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace, ); 
  }

  Future<void> insertPlayerToLiked(String username, int playerId) async {
    int? id = await getUserId(username);
    int userId = id;

    final db = await this.db;
    await db.insert(
      'user_likes_players',
      {'user_id': userId, 'player_key': playerId},
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
  }

  Future<List<Map<String, dynamic>>> getLikedPlayers(String username) async {
    final db = await this.db;
    final List<Map<String, dynamic>> likedPlayers = await db.rawQuery('''
      SELECT p.*
      FROM users u
      INNER JOIN user_likes_players ulp ON u.id = ulp.user_id
      INNER JOIN players p ON ulp.player_key = p.player_key
      WHERE u.username = ?''', 
      [username]);

  return likedPlayers;
  }

  Future<void> insertTeam(Team t) async {
    final db = await this.db;
   
    await db.insert('teams', t.toMap(), conflictAlgorithm: ConflictAlgorithm.replace, );
    if(t.players!=null){
      for(Player p in t.players!){
        Player pl = Player(player_key: p.player_key, teamId: p.teamId, playerName: p.playerName, playerImage: p.playerImage, playerAge: p.playerAge, playerType: p.playerType, playerNumber: p.playerNumber, playerRating: p.playerRating);   
        //print("player for team ${pl.teamId} with player ${p.toMap()}");
        db.insert('players', pl.toMap(), conflictAlgorithm: ConflictAlgorithm.replace, );
      }
    }
  
  }


  Future<void> insertTeamToLiked(String username, Map<String, dynamic> t) async {
    int? id = await getUserId(username);
    
    int userId = id;
    List<Player> players = (t['players'] as List).map((playerData) {
      return Player(
        player_key: playerData['player_key'],
        playerName: playerData['player_name'],
        playerImage: playerData['player_image'], 
        teamId: playerData['team_key'],
        playerAge: playerData['player_age'],
        playerNumber: playerData['player_number'],
        playerRating: playerData['player_rating'],
        playerType: playerData['player_type'],
      );}).toList();
     //print("here ${players[0].teamId}");
    Team team = Team(team_key: t['team_key'], team_name: t['team_name'], team_logo: t['team_logo'], players: players);
    //print('user id: ${id} added a team ${team.toMap()} and players ${team.players}');
    await insertTeam(team);
    final db = await this.db;
    await db.insert(
      'user_likes_teams',
      {'user_id': userId, 'team_key': t['team_key']},
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
  }

  Future<List<Map<String, dynamic>>> getLikedTeams(String username) async {
    final db = await this.db;
    final List<Map<String, dynamic>> likedTeams = await db.rawQuery('''
      SELECT t.*
      FROM users u
      INNER JOIN user_likes_teams ult ON u.id = ult.user_id
      INNER JOIN teams t ON ult.team_key = t.team_key
      WHERE u.username = ?''', 
      [username]);

  return likedTeams;

  }

  Future<List<Map<String, dynamic>>> getPlayersLikedTeam(String username, int teamKey ) async {
    final db = await this.db;
    final List<Map<String, dynamic>> likedPlayers = await db.rawQuery('''
      SELECT p.*
      FROM users u
      INNER JOIN user_likes_teams ult ON u.id = ult.user_id
      INNER JOIN teams t ON ult.team_key = t.team_key
      INNER JOIN players p ON t.team_key = p.team_key
      WHERE u.username = ? AND t.team_key = ?''',
       [username, teamKey]);

  return likedPlayers;
  }

  Future<void> deleteTeamFromLiked(int teamKey, String username) async {
    try{
    int id = await getUserId(username);
    final db = await this.db;
    int userId = id;
    await db.rawDelete('DELETE FROM user_likes_teams WHERE team_key = ? AND user_id = ?', [teamKey, userId]);
    } catch(error){
        //print('Error: $error');
    }
  }

  Future<void> deletePlayerFromLiked(int playerKey, String username) async {
    int id = await getUserId(username);

    final db = await this.db;
    int userid = id;

    await db.rawDelete('DELETE FROM user_likes_players WHERE player_key = ? AND user_id = ?', [playerKey, userid]);
  }

}
