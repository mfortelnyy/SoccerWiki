import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mp5/models/player.dart';
import 'package:mp5/utils/database_helper.dart';

import '../models/user.dart';

class PlayersScreen extends StatefulWidget {
  final String username; 
  final List<dynamic> players;
  final String teamName;
  

  const PlayersScreen({super.key, required this.username, required this.players,  required this.teamName});
  
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late List<bool> likedPlayers = [];
  late Future<User?> user;
 
  
  Future<void> liked () async {
   
   for(int i=0; i < widget.players.length; i++){
      likedPlayers.add(false);
    }
    setState(() {

    });
    
  }

  @override
  void initState()  {
    super.initState();
    liked();
    DBHelper db = DBHelper();
    user = db.getUserByUsername(widget.username);
  }
  


  Future<void> addToLikedPlayers(Map<String, dynamic> p, int playerID) async {
    DBHelper db = DBHelper();
    Player player = Player.fromJson(p);
    await db.insertPlayer(player);
    await db.insertPlayerToLiked(widget.username, playerID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(child: const Icon(Icons.arrow_back_ios), onPressed: ()  {Navigator.pop(context);},),
        title: Text('Squad - ${widget.teamName}', style: GoogleFonts.playfairDisplaySc(fontSize: 32),),
      ),
      body: ListView.builder(
        itemCount: widget.players.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> player = widget.players[index];
          int playerId = player['player_key']; 
          return Card(
            child: ListTile(
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
                  player['player_age'].isNotEmpty? Text('Age: ${player['player_age'] ?? ''} | Type: ${player['player_type'] ?? ''}') : const SizedBox() ,
                  player['player_number'].isNotEmpty ? Text('Number: ${player['player_number'] ?? ''}') : const SizedBox() ,
                  player['player_rating'].isNotEmpty ? Text('Rating (1-10): ${player['player_rating'] ?? ''}') : const SizedBox(),
  
                ],
              ),
              trailing: IconButton(
                icon: likedPlayers[index]
                    ? const Icon(Icons.favorite, color: Colors.red) 
                    : const Icon(Icons.favorite_border), 
                onPressed: () {
                  setState(() {
                    likedPlayers[index] = !likedPlayers[index]; 
                  });
                  likedPlayers[index] ? addToLikedPlayers(widget.players[index], playerId) : '';
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
