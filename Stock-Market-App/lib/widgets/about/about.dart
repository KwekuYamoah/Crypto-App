import 'package:flutter/material.dart';
import 'package:sma/shared/colors.dart';
import 'package:sma/widgets/about/attribution/attribution.dart';
import 'package:sma/widgets/widgets/empty_screen.dart';

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('About'),
          backgroundColor: Colors.indigo,
          bottom: TabBar(
            indicatorColor: Color(0X881f1f1f),
            indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Information',),
              Tab(text: 'Settings',),
            ],
          ),
        ),

        backgroundColor: kScaffoldBackground,
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              Attribution(),
              EmptyScreen(message: 'We didn\'t have time to build it.Coming in version 2.0'),
            ],
          ),
        )
      ),
    );
  }
}