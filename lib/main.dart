import 'package:coffee_maker/providers/coffee_provider.dart';
import 'package:coffee_maker/widgets/bottom_button.dart';
import 'package:coffee_maker/widgets/content.dart';
import 'package:coffee_maker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (_) => CoffeeProvider(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Card(
            margin: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TitleText(),
                Expanded(child: Content()),
                BottomButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
