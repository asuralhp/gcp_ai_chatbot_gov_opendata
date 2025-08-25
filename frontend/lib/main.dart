import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/env.dart' as env;

import 'package:frontend/pages/pagehome.dart';
import 'package:frontend/pages/pagehome.dart' as pagehome;
import 'package:frontend/widgets/buttonsubmit.dart';
import 'package:frontend/widgets/chatbox.dart' as chatbox;
import 'package:frontend/widgets/bottomsticky.dart';

void main() {
  env.initApp(stage: env.stage);
  runApp(const ChatApp());
}

const user_id = "Leo";
final chatboxgkey = GlobalKey<chatbox.ChatBoxState>();
final homekey = GlobalKey<pagehome.PageHomeState>();

class ChatApp extends StatefulWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  late int _currentIndex;
  late bool _isTapOn = true;
  late PageController _pageController;
  late List<Widget> bodyItems;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;

    bodyItems = [
      MainHome(),
      PageHome(key: homekey, chatboxgkey: chatboxgkey),
    ];

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    int _lastTap = DateTime.now().millisecondsSinceEpoch;
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    final bBound = min(mHeight, mWidth)/2.5;
    return MaterialApp(
        title: 'EventChat',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.amber,
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 46, 7, 41),
        ),
        home: Scaffold(
            // appBar: AppBar(
            //   title: const Text(
            //     'Hi! $user_id\'s, Welcome to EventChat',
            //     textAlign: TextAlign.center,
            //   ),
            //   backgroundColor: Theme.of(context).colorScheme.surfaceTint,
            // ),
            body: GestureDetector(
              onTapDown: (TapDownDetails details) => setState(() {
                _lastTap = DateTime.now().millisecondsSinceEpoch;
                _isTapOn = true;
              }),
              onHorizontalDragEnd: (details) => {
                if (_isTapOn &&
                    DateTime.now().millisecondsSinceEpoch - _lastTap < 1000)
                  {
                    setState(() {
                      _isTapOn = false;
                    }),
                    if ((details.primaryVelocity ?? 0) < 0)
                      {
                        if (_currentIndex != bodyItems.length - 1)
                          {
                            _pageController.nextPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut),
                            setState(() {
                              _currentIndex = _currentIndex + 1;
                            })
                          }
                      }
                    else
                      {
                        if (_currentIndex != 0)
                          {
                            _pageController.previousPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut),
                            setState(() {
                              _currentIndex = _currentIndex - 1;
                            })
                          }
                      }
                  }
              },
              child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: bodyItems),
            ),
            // bottomNavigationBar: BottomNavigationBar(
            //   currentIndex: _currentIndex,
            //   items: const [
            //     BottomNavigationBarItem(
            //         label: 'Section B', icon: Icon(Icons.settings)),
            //     BottomNavigationBarItem(
            //         label: 'Section A', icon: Icon(Icons.home)),
            //   ],
            //   onTap: (selectedIndex) => {
            //     setState(() {
            //       _currentIndex = selectedIndex;
            //       _pageController.jumpToPage(_currentIndex);
            //     })
            //   },
            // ),
            floatingActionButtonLocation: _currentIndex == 0
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: AnimatedCrossFade(
              crossFadeState: _currentIndex == 0
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 500),
              firstChild: Center(
                child: SubmitButton(
                    buttonHeight: bBound, buttonWidth: bBound),
              ),
              secondChild: SubmitButton(
                buttonHeight: 80.0,
                buttonWidth: 80.0,
              ),
            )));
  }
}
