import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class LiveScores extends StatefulWidget {
  const LiveScores({super.key});
  
  

  @override
  State<LiveScores> createState() => _LiveScoresState();
}

class _LiveScoresState extends State<LiveScores> {
  late List<Map<String, dynamic>> liveMatches = [];
  bool isLoading = true;

  @override
  void initState(){
    Future.delayed(const Duration(seconds: 1));
    super.initState();
    fetchLiveMatches();


  }

  Future<void> fetchLiveMatches() async {
    final url = Uri.parse('https://apiv2.allsportsapi.com/football/?met=Livescore&APIkey=76d5a73c674ba10227c4b849a88e3d13cb8eca16783c5e164f11f3bd3fae8254');
    final response = await http.get(
      url,);
    //there are not always live matches so when there are no live macthes available server response is mocked
    final Map<String, dynamic> defaultLive = {
      "success": 1,
      "result": [
      {
            "event_key": "11205",
            "event_date": "2021-05-21",
            "event_time": "11:05",
            "event_home_team": "Newcastle Jets",
            "home_team_key": "1056",
            "event_away_team": "Brisbane Roar",
            "away_team_key": "399",
            "event_halftime_result": "0 - 1",
            "event_final_result": "1 - 2",
            "event_ft_result": "1 - 2",
            "event_penalty_result": "",
            "event_status": "74",
            "country_name": "Australia",
            "league_name": "A-League - Regular Season",
            "league_key": "49",
            "league_round": "22",
            "league_season": "",
            "event_live": "1",
            "event_stadium": "McDonald Jones Stadium",
            "event_referee": "",
            "event_country_key": "17",
            "league_logo": "https://apiv2.allsportsapi.com/logo/logo_leagues/49_a-league.png",
            "country_logo": "https://apiv2.allsportsapi.com/logo/logo_country/17_australia.png",
            "event_home_formation": "",
            "event_away_formation": "",
            "fk_stage_key": "528",
            "stage_name": "Regular Season",
            "goalscorers": [
                {
                    "time": "34",
                    "home_scorer": "",
                    "score": "0 - 1",
                    "away_scorer": "R. Danzaki"
                },
                {
                    "time": "61",
                    "home_scorer": "J. O'Shea (o.g.)",
                    "score": "1 - 1",
                    "away_scorer": ""
                },
                {
                    "time": "73",
                    "home_scorer": "",
                    "score": "1 - 2",
                    "away_scorer": "J. O'Shea"
                }
            ],
            "cards": [
                {
                    "time": "21",
                    "home_fault": "",
                    "card": "yellow card",
                    "away_fault": "M. Gillesphey"
                },
                {
                    "time": "42",
                    "home_fault": "J. Hoffman",
                    "card": "yellow card",
                    "away_fault": ""
                },
            ],
            "substitutes": [
                {
                    "time": "46",
                    "home_scorer": {
                        "in": "C. O'Toole",
                        "out": "L. Mauragis"
                    },
                    "score": "substitution",
                    "away_scorer": []
                },
                {
                    "time": "46",
                    "home_scorer": {
                        "in": "A. Abbas",
                        "out": "A. Goodwin"
                    },
                    "score": "substitution",
                    "away_scorer": []
                },
            ],
            "lineups": {
                "home_team": {
                    "starting_lineups": [
                        {
                            "player": "Jack Duncan",
                            "player_number": "23",
                            "player_country": null
                        },
                        {
                            "player": "Johnny Koutroumbis",
                            "player_number": "2",
                            "player_country": null
                        },
                    ],
                    "substitutes": [
                        {
                            "player": "Lewis Italiano",
                            "player_number": "1",
                            "player_country": null
                        },
                        {
                            "player": "Lachlan Jackson",
                            "player_number": "22",
                            "player_country": null
                        },
                    ],
                    "coaches": [
                        {
                            "coache": "W. Moon",
                            "coache_country": null
                        }
                    ]
                }
            },
            "statistics": [
                {
                    "type": "Shots Blocked",
                    "home": "1",
                    "away": "6"
                },
                {
                    "type": "Shots Inside Box",
                    "home": "3",
                    "away": "8"
                },
                {
                    "type": "Shots Outside Box",
                    "home": "3",
                    "away": "8"
                },
            ]
        },
      ]
    };

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == 1) {
        final List<dynamic>? matches = jsonData['result'];
        if (matches != null && matches.isNotEmpty) {
          setState(() {
            liveMatches = List<Map<String, dynamic>>.from(matches);
            isLoading = false;
          });
        }
        else{
          liveMatches = List<Map<String, dynamic>>.from(defaultLive['result']);
          setState(() {
            isLoading = false;
          });
        }
      }
    }
    else
    {
      liveMatches = List<Map<String, dynamic>>.from(defaultLive['result']);
      setState(() {
            isLoading = false;
          });
    }
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Matches', style: GoogleFonts.playfairDisplaySc(fontSize: 32),),
        backgroundColor: const Color.fromRGBO(166, 249, 206, 0.808),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : liveMatches.isEmpty
           ?  Text("No live Matches Right Now! Check again later", style: GoogleFonts.playfairDisplaySc(fontSize: 32),)
           :  ListView.builder(
              itemCount: liveMatches.length,
              itemBuilder: (context, index) {
                final match = liveMatches[index];

                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('${match['event_home_team']} vs ${match['event_away_team']}'),
                        subtitle: Text('League: ${match['league_name']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Halftime Result: ${match['event_halftime_result']}'),
                                Text('Final Result: ${match['event_final_result']}'),
                              ],
                            ),
                            Image.network(
                              match['league_logo'] ?? '',
                              height: 50,
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                      match['goalscorers'].isNotEmpty 
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Goalscorers:'),
                              for (var scorer in match['goalscorers'])
                                Text('${scorer['time']} - ${scorer['home_scorer']} ${scorer['score']} ${scorer['away_scorer']}'),
                            ],
                          )
                        : const SizedBox(), 
                      match['cards'].isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Cards:'),
                              for (var card in match['cards'])
                                Text('${card['time']} - ${card['home_fault']} ${card['card']} ${card['away_fault']}'),
                            ],
                          )
                        : const SizedBox(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
  