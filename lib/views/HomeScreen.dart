import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:mp5/utils/database_helper.dart';
import 'package:mp5/utils/sessionmanager.dart';
import 'package:mp5/views/LoginScreen.dart';
import 'FavoritePlayersScreen.dart';
import 'FavoriteTeamsScreen.dart';
import 'LiveScores.dart';
import 'PlayersScreen.dart';


class HomeScreen extends StatefulWidget {
  final String username ;
  List<Map<String, dynamic>>? allTeams;
  HomeScreen({required this.username, super.key, this.allTeams });
  
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  late List<Map<String, dynamic>> allTeams = widget.allTeams ?? [];
  bool isLoading = true;
  late List<bool> likedTeams = [];
  


  @override
  void initState() {
    super.initState();

    fetchAllTeams();

  }


  Future<void> fetchAllTeams() async{
    for (int i=0; i < 27; i++) {
      await fetchTeam(i);
    }
    setState(() {
      isLoading = false;
      for(int i =0; i<allTeams.length; i++){
        likedTeams.add(false);
      }
    });
  }

  Future<void> fetchTeam(int i) async {
    final url = Uri.parse('https://apiv2.allsportsapi.com/football/?&met=Teams&teamId=$i&APIkey=76d5a73c674ba10227c4b849a88e3d13cb8eca16783c5e164f11f3bd3fae8254');
    dynamic response;
    if(widget.allTeams == null){
      response= await http.get(
        url,
        headers: {});
    }
    else{
      response.statusCode = 400;
    }
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == 1) {
        final result = jsonData['result'];
        if (result != null) {
            List<Map<String, dynamic>> players = List<Map<String, dynamic>>.from(result[0]['players'] ?? []);
            int teamKey = result[0]['team_key'];
            for (int j = 0; j < players.length; j++) {
              players[j]['team_key'] = teamKey;
            }
            allTeams.add({
              'team_key': result[0]['team_key'],
              'team_name': result[0]['team_name'],
              'team_logo': result[0]['team_logo'],
              'players': players,
            });
        }
      }
    }
   }

    _logOut(context) {
    SessionManager.clearSession();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
   }

   _favoriteTeams(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavoriteTeamsScreen(username: widget.username,),    
      ),   
    );
   }

   _favoritePlayers(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavoritePlayersScreen(username: widget.username,),
      ),
    );
   }

   _liveScores(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LiveScores(),
      ),
    );
   }

  Drawer _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color:  Color.fromRGBO(166, 249, 206, 0.808),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Logged in as ${widget.username}',style: GoogleFonts.playfairDisplaySc(fontSize: 18, color: Colors.black),),
              ]
            )
          ),
          const SizedBox(height: 200,),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.favorite_rounded, color: Colors.red,  size: 45,),
                  SizedBox(width: 16),
                  Text('Favorite Teams', style: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.bold,),),
              ],
            ),
            onTap:() { _favoriteTeams(); },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 45,),
                  SizedBox(width: 16),
                  Text('Favorite Players', style: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.bold),),
              ],
            ),
            onTap:() { _favoritePlayers(); },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.sports_soccer, color: Colors.white, size: 45,),
                  SizedBox(width: 16),
                  Text('Live Scores', style: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.bold),),
              ],
            ),
            onTap:() => _liveScores(),
          ),
          const Divider(),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.logout, color: Colors.white, size: 45,),
                  SizedBox(width: 16),
                  Text('Log Out', style: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.bold),),
              ],
            ),
            onTap:() => _logOut(context),
          ),
        ]
      )
    ));
  }

  Future<void> addToLikedTeams(Map<String, dynamic> t ) async { 
    DBHelper db = DBHelper();
    db.insertTeamToLiked(widget.username, t);
  
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams', style: GoogleFonts.playfairDisplaySc(fontSize: 32),),
        backgroundColor: const Color.fromRGBO(166, 249, 206, 0.808),
      ),
      drawer: _buildDrawer(),
      body: isLoading  
      ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Please wait until the home screen loads',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        )
      : ListView.builder(
        itemCount: allTeams.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Image.network(allTeams[index]['team_logo'],
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.account_box_rounded, color: Colors.white,); 
                },
              ),
            ),
            title: Text(allTeams[index]['team_name'] ?? 'Team Name'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlayersScreen(username: widget.username, players:allTeams[index]['players'], teamName: allTeams[index]['team_name'],),
                ),
              );
              (allTeams[index]['players'] ?? []);
            },
            subtitle:const SizedBox(height: 15,),
            trailing: IconButton(
                icon: likedTeams[index]
                    ? const Icon(Icons.favorite, color: Colors.red) 
                    : const Icon(Icons.favorite_border), 
                onPressed: () {
                  setState(() {
                    likedTeams[index] = !likedTeams[index]; 
                  });
                  likedTeams[index] ? addToLikedTeams(allTeams[index],) : '';
                },
              ),
          );
        },
      ),
    );
  }
}


