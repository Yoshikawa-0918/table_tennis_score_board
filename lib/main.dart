import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _redCounter = 0;
  int _blackCounter = 0;
  int _redSetCounter = 0;
  int _blackSetCounter = 0;
  var _player1Controller = TextEditingController();
  var _player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    void _redIncrementCounter() {
      setState(() {
        _redCounter++;
        if (_redCounter >= 11 && (_redCounter - _blackCounter) >= 2) {
          _redCounter = 0;
          _blackCounter = 0;
          _redSetCounter++;
        }
      });
    }

    void _blackIncrementCounter() {
      setState(() {
        _blackCounter++;
        if (_blackCounter >= 11 && (_blackCounter - _redCounter) >= 2) {
          _blackCounter = 0;
          _redCounter = 0;
          _blackSetCounter++;
        }
      });
    }

    void _redDecrementCounter() {
      setState(() {
        _redCounter--;
        if (_redCounter < 0) {
          _redCounter = 0;
        }
      });
    }

    void _blackDecrementCounter() {
      setState(() {
        _blackCounter--;
        if (_blackCounter < 0) {
          _blackCounter = 0;
        }
      });
    }

    void _resetAllCount() {
      setState(() {
        _redCounter = 0;
        _blackCounter = 0;
        _redSetCounter = 0;
        _blackSetCounter = 0;
      });
    }

    void _courtChange() {
      setState(() {
        //得点の値入れ替え
        int tmp1 = 0;
        tmp1 = _redCounter;
        _redCounter = _blackCounter;
        _blackCounter = tmp1;

        //セット数の値入れ替え
        int tmp2 = 0;
        tmp2 = _redSetCounter;
        _redSetCounter = _blackSetCounter;
        _blackSetCounter = tmp2;

        //プレイヤー名の入れ替え
        var tmp3 = '';
        tmp3 = _player1Controller.text;
        _player1Controller.text = _player2Controller.text;
        _player2Controller.text = tmp3;
      });
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //左の得点板
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                        width: (size.width / 7) * 2,
                        height: size.height / 7,
                        child: TextFormField(
                          controller: _player1Controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                              ),
                            ),
                            hintText: 'Player1',
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  SizedBox(
                    width: (size.width / 7) * 2,
                    height: (size.height / 7) * 5,
                    child: Card(
                      color: Colors.black,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text('$_redCounter',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 170,
                                  color: _redCounter >= 10 &&
                                          (_redCounter - _blackCounter) >= 1
                                      ? Colors.yellow
                                      : Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  //左の得点板の操作ボタン
                  SizedBox(
                    width: (size.width / 7) * 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: size.width / 10,
                          child: ElevatedButton(
                            onPressed: _redIncrementCounter,
                            child: Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black26,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 10,
                          child: ElevatedButton(
                            onPressed: _redDecrementCounter,
                            child: Icon(
                              Icons.remove,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ), //サーブ圏(サーブは二回ずつ)、セット数を-1するときにゲームも1セット前に戻る
              //中央のセット数・リセット・コートチェンジ
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 14,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _redSetCounter++;
                            });
                          },
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: const Icon(
                                Icons.add,
                              )),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black26,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 14,
                        child: ElevatedButton(
                          onPressed: () {
                            _redSetCounter--;
                            setState(() {
                              if (_redSetCounter < 0) {
                                _redSetCounter = 0;
                              }
                            });
                          },
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: const Icon(Icons.remove)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black26,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width / 55),
                      SizedBox(
                        width: size.width / 14,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _blackSetCounter++;
                            });
                          },
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: const Icon(Icons.add)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black26,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 14,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _blackSetCounter--;
                              if (_blackSetCounter < 0) {
                                _blackSetCounter = 0;
                              }
                            });
                          },
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: const Icon(Icons.remove)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //中央のセット数
                  Row(
                    children: [
                      SizedBox(
                        width: (size.width / 8),
                        height: (size.height / 11) * 4,
                        child: Card(
                          color: Colors.black,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '$_redSetCounter',
                                style: TextStyle(
                                  fontSize: size.width / 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: size.width / 8,
                        height: (size.height / 11) * 4,
                        child: Card(
                          color: Colors.black,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '$_blackSetCounter',
                                style: TextStyle(
                                  fontSize: size.width / 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  //中央のリセットボタン
                  SizedBox(
                    width: size.width / 4,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _resetAllCount,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text('リセット',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black26,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //中央のコートチェンジ
                  SizedBox(
                    width: size.width / 4,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _courtChange,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text('コートチェンジ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black26,
                      ),
                    ),
                  )
                ],
              ),

              //右の得点板
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                        width: (size.width / 7) * 2,
                        height: size.height / 7,
                        child: TextFormField(
                          controller: _player2Controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            hintText: 'Player2',
                          ),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    width: (size.width / 7) * 2,
                    height: (size.height / 7) * 5,
                    child: Card(
                      color: Colors.black,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text('$_blackCounter',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 170,
                                  color: _blackCounter >= 10 &&
                                          (_blackCounter - _redCounter) >= 1
                                      ? Colors.yellow
                                      : Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (size.width / 7) * 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: size.width / 10,
                          child: ElevatedButton(
                            onPressed: _blackIncrementCounter,
                            child: Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black26,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 10,
                          child: ElevatedButton(
                            onPressed: _blackDecrementCounter,
                            child: Icon(
                              Icons.remove,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
