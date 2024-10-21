import 'player.dart';
import 'team.dart';

class User {
  int? id;
  String username;
  String password; 
  List<Team>? teams; 
  List<Player>? players;

  User({
    this.id,
    required this.username,
    required this.password,
    this.teams,
    this.players,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
  final teamsList = map['teams'] as List<dynamic>?;
  final playersList = map['players'] as List<dynamic>?;

  final teams = teamsList?.map((teamMap) => Team.fromJson(teamMap)).toList() ?? [];
  final players = playersList?.map((playerMap) => Player.fromJson(playerMap)).toList() ?? [];

  return User(
    id: map['id'],
    username: map['username'],
    password: map['password'],
    teams: teams,
    players: players,
  );
}

  void addTeam(Team t){
    teams?.add(t);
  }

  void addPlayer(Player p){
    players?.add(p);
  }
}