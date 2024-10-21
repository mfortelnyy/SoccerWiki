import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/database_helper.dart';
import 'PlayersFromLikedTeams.dart';



class FavoriteTeamsScreen extends StatefulWidget {
  final String username;
  const FavoriteTeamsScreen({super.key, required this.username});
  
  

  @override
  State<FavoriteTeamsScreen> createState() => _FavoriteTeamsScreenScreenState();
}

class _FavoriteTeamsScreenScreenState extends State<FavoriteTeamsScreen> {
  late List<Map<String, dynamic>> likedTeams = [];
  bool isLoading = false;
  
  @override
   void initState() {
    super.initState();
    fetchLikedTeams();
  }

  Future<void> fetchLikedTeams() async {
    DBHelper dbHelper = DBHelper();

    List<Map<String, dynamic>> teams = await dbHelper.getLikedTeams(widget.username);
    
    setState(() {
      likedTeams = teams;
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Teams', style: GoogleFonts.playfairDisplaySc(fontSize: 32),),
        backgroundColor: const Color.fromRGBO(166, 249, 206, 0.808),
      ),
      body: isLoading
      ? const Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: likedTeams.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) async {
              
              DBHelper dbHelper = DBHelper();
              dbHelper.deleteTeamFromLiked(likedTeams[index]['team_key'], widget.username);
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {fetchLikedTeams();});
  
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
            leading: Image.network(likedTeams[index]['team_logo']),
            title: Text(likedTeams[index]['team_name'] ?? 'Team Name'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlayersFromLikedTeams(username: widget.username,  team_key: likedTeams[index]['team_key'], team_name: likedTeams[index]['team_name'],),
                ),
              );
              (likedTeams[index]['players'] ?? []);
            },
            subtitle:const SizedBox(height: 15,),
          ),
        );},
      ),
    );
  }

}
  