// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/main.dart';
import 'package:mp5/models/player.dart';
import 'package:mp5/models/team.dart';




void main() {
  test('Player toMap() Test', () {
      final player = Player(
        player_key: 1,
        teamId: 1,
        playerImage: 'qqq',
        playerAge: '45',
        playerNumber: '11',
        playerRating: '7.0',
        playerType: 'Defender',
        playerName: 'Albert Einstein',
        
      );

      final map = player.toMap();

      expect(map['player_key'], 1);
      expect(map['player_name'], 'Albert Einstein');
      expect(map['player_age'], '45');
    });

    test('Player fromJson() Test ', () {
      final json = {
        'player_key': 2,
        'team_key': 1,
        'player_name': 'Albert Einstein',
        'player_age' : '99',
        'player_rating' : '8.1', 
        'player_type': 'Midfielder',
        'player_number': '12',
       
      };

      final player = Player.fromJson(json);

      expect(player.player_key, 2);
      expect(player.playerName, 'Albert Einstein');
      expect(player.playerAge,'99' );
    });

    test('Player Test1', () {
      final player1 = Player(
        player_key: 3,
        teamId: 1,
        playerName: 'Albert Einstein',
        playerImage: 'qqq',
        playerAge: '99',
        playerNumber: '12',
        playerRating: '8.1',
        playerType: 'Midfielder',
      );

      final json = {
        'player_key': 3,
        'team_key': 1,
        'player_name': 'Albert Einstein',
        'player_age' : '99',
        'player_rating' : '8.1', 
        'player_type': 'Midfielder',
        'player_number': '12',
      };

      final player2 = Player.fromJson(json);
      
      //even though they have the same data, they should have different reference
      expect(player1, isNot(player2)); 
    });

     test('Player Test2', () {
      final player1 = Player(
        player_key: 3,
        teamId: 1,
        playerName: 'Albert Einstein',
        playerImage: 'qqq',
        playerAge: '99',
        playerNumber: '12',
        playerRating: '8.1',
        playerType: 'Midfielder',
      );

      final json = {
        'player_key': 3,
        'team_key': 1,
        'player_name': 'Albert Einstein',
        'player_age' : '99',
        'player_rating' : '8.1', 
        'player_type': 'Midfielder',
        'player_number': '12',
      };

      final player2 = Player.fromJson(json);
      
      
      expect(player1.toString(), player2.toString()); 
    });

    test('Team data Test', () {
      final team1 = Team(
        team_key: 2,
        team_logo: 'qqq',
        team_name: 'Chicago Fire',
        players: null,
      );

      final json = {
        'team_key': 2,
        'team_logo': 'qqq',
        'team_name': 'Chicago Fire'
      };

      final team2 = Team.fromJson(json);

      expect(team1.team_name, team2.team_name); 
      expect(team1.team_key, team2.team_key); 
      expect(team1.team_logo, team2.team_logo); 
      expect(team1.players, team2.players);
    });

   

  testWidgets('Log in Test', (WidgetTester tester) async {

      await tester.pumpWidget(const Start()); 
      await tester.pumpAndSettle();

      //if not logged in than sign in should be displayed
      expect(find.text('Sign In'), findsAny);
  });  

}
