import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/database_helper.dart';


class FavoritePlayersScreen extends StatefulWidget {
  final String username;
  const FavoritePlayersScreen({super.key, required this.username});
  
  

  @override
  State<FavoritePlayersScreen> createState() => _FavoritePlayersScreenState();
}

class _FavoritePlayersScreenState extends State<FavoritePlayersScreen> {
  late List<Map<String, dynamic>> likedPlayers = [];
  
  @override
   void initState() {
    super.initState();
    fetchLikedPlayers();
  }

  Future<void> fetchLikedPlayers() async {
    DBHelper dbHelper = DBHelper();


    List<Map<String, dynamic>> players = await dbHelper.getLikedPlayers(widget.username);
    
    setState(() {
      likedPlayers = players;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Players', style: GoogleFonts.playfairDisplaySc(fontSize: 32),),
        backgroundColor: const Color.fromRGBO(166, 249, 206, 0.808),
      ),
      body: ListView.builder(
        itemCount: likedPlayers.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> player = likedPlayers[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) async {
              
              DBHelper dbHelper = DBHelper();
              dbHelper.deletePlayerFromLiked(likedPlayers[index]['player_key'], widget.username);
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {fetchLikedPlayers();});
  
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
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
                  Text('Age: ${player['player_age'] ?? ''} | Type: ${player['player_type'] ?? ''}'),
                  
                  ],
            ),  
          ));
        },
      ),
    );
  }
}
  