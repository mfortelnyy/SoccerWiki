class Player {
  final int player_key;
  final int teamId;
  final String playerName; 
  final String? playerImage;
  final String playerAge;
  final String playerType;
  final String playerNumber;
  final String playerRating;
  
 

  Player({
    required this.player_key,
    required this.teamId,
    required this.playerName,
    required this.playerImage,
    required this.playerAge,
    required this.playerType,
    required this.playerNumber,
    required this.playerRating,
    
    
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      player_key: json['player_key'],
      teamId: json['team_key'],
      playerName: json['player_name'],
      playerImage: json['player_image'],
      playerAge: json['player_age'],
      playerType: json['player_type'],
      playerNumber: json['player_number'] ?? "",
      playerRating: json['player_rating'], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'player_key': player_key,
      'team_key': teamId,
      'player_name': playerName,
      'player_image': playerImage,
      'player_age': playerAge,
      'player_type': playerType.substring(0,playerType.length-1),
      'player_number': playerNumber,
      'player_rating': playerRating
      
    };
  }
}
