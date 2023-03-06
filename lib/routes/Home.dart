import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Padding(padding: EdgeInsets.only(top: 70)),
                  Text(
                    'Авторизация',
                    style: TextStyle(fontFamily: 'PT Sans Caption', fontSize: 30),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}
