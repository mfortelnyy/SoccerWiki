import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/database_helper.dart';


class PlayersFromLikedTeams extends StatefulWidget {
  final String username;
  final int team_key;
  final String team_name;
  const PlayersFromLikedTeams({super.key, required this.username, required this.team_key, required this.team_name});
  
  

  @override
  State<PlayersFromLikedTeams> createState() => _PlayersFromLikedTeamsState();
}

class _PlayersFromLikedTeamsState extends State<PlayersFromLikedTeams> {
  late List<Map<String, dynamic>> likedPlayers = [];
  
  @override
   void initState() {
    super.initState();
    fetchPlayersLikedTeam();
  }

  Future<void> fetchPlayersLikedTeam() async {
    DBHelper dbHelper = DBHelper();


    List<Map<String, dynamic>> players = await dbHelper.getPlayersLikedTeam(widget.username, widget.team_key);
    
    setState(() {
      likedPlayers = players;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players from Favorite Team \n                  ${widget.team_name}', style: GoogleFonts.playfairDisplaySc(fontSize: 18),),
        backgroundColor: const Color.fromRGBO(166, 249, 206, 0.808),
      ),
      body: ListView.builder(
        itemCount: likedPlayers.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> player = likedPlayers[index];

          return ListTile(
            leading: CircleAvatar(
              child: Image.network(
                player['player_image'] ?? '',
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.account_box_rounded, color: Colors.white,); 
                },
              ),
            ),
            title: Text(player['player_name'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text('Age: ${player['player_age'] ?? ''} | Type: ${player['player_type'] ?? ''}'),
              ],
            ), 
          );
        },
      ), 
    );
  }
}