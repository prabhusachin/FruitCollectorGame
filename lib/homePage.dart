import 'dart:async';
import 'package:flutter/material.dart';
import 'ball.dart';
import 'brick.dart';
import 'dart:math';
import 'welcomeScreen.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
enum direction { UP, DOWN, LEFT, RIGHT }
class _HomePageState extends State<HomePage> {
  String playresult="";
  double playerX = -0.2,brickWidth = 0.4,ballx = 0,bally = 0,ballx1 = 0,bally1 = 0,idirup=0,idirup1=0;
  int playerScore = 0,idir = 0,idir1 = 0, iattempt = 0, iattemptflg = 0, iattflg = 0, iattflg1 = 0,iattcnt = 0,iattcnt1 = 0, ilevel = 2, iflag = 0,iflg=0,iflg1=0;
  var ballYDirection = direction.DOWN,ballYDirection1 = direction.DOWN;
  var ballXDirection = direction.RIGHT,ballXDirection1 = direction.RIGHT;
  bool gameStarted = false;
  void startGame() {
    gameStarted = true;
    checkballposn();
    Timer.periodic(Duration(milliseconds: 25), (timer) {
      updatedDirection();
      moveBall();
      if(playerScore>=((ilevel==1)?12:6)) playresult="You Won!";
      if (iattempt==11) playresult="You Lost!";
      if (playerScore>=((ilevel==1)?12:6) || iattempt==11) {
        gameStarted = false;
        timer.cancel();
        _showDialog(false);
      }
    });
  }
  void checkballposn() {
    idir = Random().nextInt(2) + 1;
    idir1 = Random().nextInt(2) + 1;
    ballx = getballposn(Random().nextInt(5) + 1);
    bally = getballposn(Random().nextInt(5) + 1);
    ballx1 = getballposn(Random().nextInt(5) + 1);
    bally1 = getballposn(Random().nextInt(5) + 1);
    if(idir==1) ballXDirection = direction.LEFT;
    if(idir==2) ballXDirection = direction.RIGHT;
    if(idir1==1) ballXDirection1 = direction.LEFT;
    if(idir1==2) ballXDirection1 = direction.RIGHT;
    iattemptflg = iattflg = iattflg1 = iattcnt = iattcnt1 = iflag = iflg=iflg1=0;
    idirup=idirup1=0;
  }
  void _showDialog(bool enemyDied) {
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) { // return object of type Dialog
          return AlertDialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.purple,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "$playresult\nLevel $ilevel completed",
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              setState(() {
                                if (ilevel > 1 && iflag == 0) {
                                  iflag = 1;
                                  ilevel = ilevel - 1;
                                  resetGame();
                                }
                              });
                            },
                            child: const Text('Prev Level'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 1),
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  if (ilevel < 2 && iflag == 0) {
                                    iflag = 1;
                                    ilevel = ilevel + 1;
                                    resetGame();
                                  }
                                });
                              }, child: const Text('Next Level'),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 35),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              resetGame();
                            });
                          }, child: const Text('Current Level'),
                        ),
                      ),
                    ],),
                ],),
            ),
          );
     });
  }
  void resetGame() {
    Navigator.pop(context);
    setState(() {
      gameStarted = false;
      playerScore = iattempt = 0;
      playerX = -0.2;
      startGame();
    });
  }
  double getballposn(int ival) {
    if(ival==1) return (-0.8);
    if(ival==2) return (-0.6);
    if(ival==3) return (-0.4);
    if(ival==4) return (-0.2);
    if(ival==5) return (0);
    return 0;
  }
  void updatedDirection() {
    setState(() { //update vertical direction
      if(ilevel == 2 && ballYDirection == direction.UP && bally <= idirup && iflg==0) ballYDirection = direction.DOWN;
      if (bally >= 0.9 && playerX + brickWidth >= ballx && playerX <= ballx && iattflg == 0 && iflg==0 && ballYDirection == direction.DOWN) {
        iattflg = 1;
        if (ilevel == 1) playerScore++;
        if (ilevel == 2) {
          iattcnt++;
          if (iattcnt < 4) {
            ballYDirection = direction.UP;
            idirup = getballposn(Random().nextInt(5) + 1);
            iattflg=0;
          }
        }
      } else if (ilevel == 2 && bally >= 1 && iattcnt < 4) iflg=1;
      else if (ilevel == 2 && bally >= 0.9 && playerX + brickWidth >= ballx && playerX <= ballx && iflg==0 && iattcnt == 4) { playerScore++; iattcnt++; }
      if(ilevel == 2 && ballYDirection1 == direction.UP && bally1 <= idirup1 && iflg1==0) ballYDirection1 = direction.DOWN;
      if (bally1 >= 0.9 && playerX + brickWidth >= ballx1 && playerX <= ballx1 && iattflg1 == 0 && iflg1==0 && ballYDirection1 == direction.DOWN) {
        iattflg1 = 1;
        if (ilevel == 1) playerScore++;
        if (ilevel == 2) {
          iattcnt1++;
          if (iattcnt1 < 4) {
            ballYDirection1 = direction.UP;
            idirup1 = getballposn(Random().nextInt(5) + 1);
            iattflg1=0;
          }
        }
      } else if (ilevel == 2 && bally1 >= 1 && iattcnt1 < 4) iflg1=1;
      else if (ilevel == 2 && bally1 >= 0.9 && playerX + brickWidth >= ballx1 && playerX <= ballx1 && iflg1==0 && iattcnt1 == 4) { playerScore++; iattcnt1++; }
      if (ballx >= 1) ballXDirection = direction.LEFT; // update horizontal directions
      else if (ballx <= -1) ballXDirection = direction.RIGHT;
      if (ballx1 >= 1) ballXDirection1 = direction.LEFT; // update horizontal directions
      else if (ballx1 <= -1) ballXDirection1 = direction.RIGHT;
      if (bally >= 1 && bally1 >= 1 && iattemptflg == 0 && ballYDirection == direction.DOWN && ballYDirection1 == direction.DOWN) {
        iattemptflg = 1;
        iattempt++;
        checkballposn();
      }
    });
  }
  void moveBall() {
    setState(() { //vertical movement
      if (ballYDirection == direction.DOWN && iflg==0) bally += 0.01;
      if (ballYDirection1 == direction.DOWN && iflg1==0) bally1 += 0.01;
      if (ballYDirection == direction.UP && iflg==0) bally -= 0.01;
      if (ballYDirection1 == direction.UP && iflg1==0) bally1 -= 0.01;
      if (ballXDirection == direction.LEFT && iflg==0) ballx -= 0.01;
      else if (ballXDirection == direction.RIGHT && iflg==0) ballx += 0.01;
      if (ballXDirection1 == direction.LEFT && iflg1==0) ballx1 -= 0.01;
      else if (ballXDirection1 == direction.RIGHT && iflg1==0) ballx1 += 0.01;
    });
  }
  void moveLeft() {
    setState(() { if (!(playerX - 0.1 <= -1)) playerX -= 0.2; });
  }
  void moveRight() {
    if (!(playerX + brickWidth >= 1)) playerX += 0.2;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Stack(
            children: [
              Align(alignment: Alignment.topCenter,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Score=$playerScore\nLevel=$ilevel",style: TextStyle(color: Colors.white),),
                  ],),
              ),
              Welcome(gameStarted),
              Score(gameStarted,playerScore), //scoreboard
              Ball(ballx, bally), // ball
              Ball(ballx1, bally1), // ball
              Brick(playerX, 0.9, brickWidth, false), // //bottom brick
              Align(alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () { moveLeft(); },
                      color: Colors.yellow,
                      child: Icon(Icons.keyboard_arrow_left),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: RaisedButton(
                        onPressed: () { moveRight(); },
                        color: Colors.yellow,
                        child: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Score extends StatelessWidget {
  final gameStarted,playerScore;
  Score(this.gameStarted, this.playerScore, );
  @override
  Widget build(BuildContext context) {
    return gameStarted? Stack(children: [
      Container(
          alignment: Alignment(0, 0),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width / 3,
            color: Colors.grey[800],
          )),
      Container(
          alignment: Alignment(0, 0.3),
          child: Text(
            playerScore.toString(),
            style: TextStyle(color: Colors.grey[800], fontSize: 100),
          )),
    ]): Container();
  }
}