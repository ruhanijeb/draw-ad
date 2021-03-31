import 'package:learn_drawing/add_manager.dart';
import 'package:learn_drawing/theme_app.dart';
import 'package:learn_drawing/drwaing_painter.dart';
import 'package:learn_drawing/drawing.dart';
import 'package:learn_drawing/quiz_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';    

class GameRoute extends StatefulWidget{
  @override
  _GameRouteState createState()=>_GameRouteState();
}
class _GameRouteState extends State<GameRoute> implements QuizEventListener{
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey<ScaffoldState>();
  int _level;
  Drawing _drawing;
  String _clue;
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;
  bool _isRewardedAdReady;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    QuizManager.instance
    ..listener=this..startGame();
    _isInterstitialAdReady=false;
    _isRewardedAdReady=false;
    _bannerAd=BannerAd(adUnitId: AddManager.bannerAdUnitId, 
        size: AdSize.banner);
    _interstitialAd=InterstitialAd(
      adUnitId: AddManager.interstialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    RewardedVideoAd.instance.listener=_onRewardedAdEvent;
    _loadBannerAd();
    _loadRewardedAd();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyAppTheme.primary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                      'Level $_level/10',
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                          builder: (context){
                              String _answer='';
                              return AlertDialog(
                                title: Text('Enter your answer'),
                                content: TextField(
                                  autofocus: true,
                                  onChanged: (value){
                                    _answer=value;
                                  },
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                        QuizManager.instance.checkAnswer(_answer);
                                      }, 
                                      child: Text('Submit'.toUpperCase()))
                                ],
                              );
                          }
                        );
                      },
                      child: Text(
                          _clue,
                        style: TextStyle(fontSize: 24),
                      ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16)),
                  SizedBox(height: 20,),
                  Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          child: CustomPaint(
                            size: Size(300,300),
                            painter: DrawingPainter(drawing: _drawing),

                          ),
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: EdgeInsets.all(16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        child: ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            FlatButton(
                onPressed: (){
                 QuizManager.instance.nextLevel();
                },
                child: Text('Skip this level'.toUpperCase())
            )
          ],
        ),
      ),
    );
  }
  Widget _buildFloatingActionButton(){
    return (!QuizManager.instance.isHintUsed&&_isRewardedAdReady)
        ?FloatingActionButton.extended(
        onPressed: (){
          showDialog(
              context: context,
            builder: (context){
                return AlertDialog(
                  title: Text('Need a hint?'),
                  content: Text('Watch an ad to get a hint'),
                  actions: [
                    FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                          RewardedVideoAd.instance.show();
                        }
                    , child: Text('ok'.toUpperCase()))
                  ],
                );
            }
          );
        },
        label: Text('hint'),
      icon: Icon(Icons.card_giftcard),
    ):Container();
  }
  void _moveToHome(){
    Navigator.pushNamedAndRemoveUntil(_scaffoldKey.currentContext, '/', (_) => false);
  }
  void _showSnackBar(String message){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message))
    );
  }
  void _loadBannerAd(){
    _bannerAd..load()..show(anchorType: AnchorType.top);
  }
  void _loadInterstitialAd(){
    _interstitialAd.load();
  }
  void _loadRewardedAd(){
    RewardedVideoAd.instance.load(adUnitId: AddManager.rewardedAdUnitId,targetingInfo: MobileAdTargetingInfo());
  }
  void _onInterstitialAdEvent(MobileAdEvent event){
    switch(event){
      case MobileAdEvent.loaded:
        _isInterstitialAdReady=true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady=false;
        break;
      case MobileAdEvent.closed:
        _moveToHome();
        break;
      default:
        //do nothing
    }
  }
  void _onRewardedAdEvent(RewardedVideoAdEvent event,{String rewardType,int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isRewardedAdReady = true;
        });
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isRewardedAdReady = false;
        });
        _loadRewardedAd();
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isRewardedAdReady = false;
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        QuizManager.instance.useHint();
        break;
      default:
      //do nothing
    }
  }
    @override
    void dispose(){
      _bannerAd?.dispose();
      _interstitialAd?.dispose();
      RewardedVideoAd.instance.listener=null;
      QuizManager.instance.listener=null;
      super.dispose();
    }
    @override
    void onGameOver(int correctAnswers){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Game Over!'),
              content: Text('Score: $correctAnswers/10'),
              actions: [
                FlatButton(
                    onPressed: (){
                      if(_isInterstitialAdReady){
                        _interstitialAd.show();
                      }
                      _moveToHome();
                    },
                    child: Text('close'.toUpperCase())
                )
              ],
            );
          }
      );

  }
  @override
  void onClueUpdated(String clue){
    setState(() {
      _clue=clue;
    });
    _showSnackBar('you\'ve got one more clue!');
  }


  @override
  void onLevelCleared() {
    _showSnackBar('Good Job!');
  }

  @override
  void onNewLevel(int level, Drawing drawing, String clue) {
    setState(() {
      _level = level;
      _drawing = drawing;
      _clue = clue;
    });
    if (level >= 3 && _isInterstitialAdReady) {
      _loadInterstitialAd();
    }

  }

  @override
  void onWrongAnswer() {
    _showSnackBar('Wrong answer');
  }
}