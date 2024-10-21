import 'player.dart';

class Team {
  final int team_key;
  final String team_name;
  final String team_logo;
  final List<Player>? players;

  Team({
    required this.team_key,
    required this.team_name,
    required this.team_logo,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    if(!(json['players'] == null || json['players'].isEmpty))
    {
      List<Player> players = (json['players'] as List)
          .map((player) => Player.fromJson(player))
          .toList();

      return Team(
        team_key: json['team_key'],
        team_name: json['team_name'],
        team_logo: json['team_logo'],
        players: players,
      );
    }
    else
    {
      return Team(
        team_key: json['team_key'],
        team_name: json['team_name'],
        team_logo: json['team_logo'],
        players: null,
      );
    }
  }

  void add(Player p){
    players?.add(p);
  }

  Map<String, dynamic> toMap() {
    return {
      'team_key': team_key,
      'team_name': team_name,
      'team_logo': team_logo,
    };
  }

}
