import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class LedPinLevelStore with ChangeNotifier {
  List<List<bool>> ledLevels = [
    List.generate(9, (index) => false),
    List.generate(9, (index) => false),
    List.generate(9, (index) => false)
  ];

  void changePinLevel ({int cathodeNumber, int anodeNumber, bool anodeLevel}) {
    ledLevels[cathodeNumber][anodeNumber] = anodeLevel;
    print(ledLevels[cathodeNumber][anodeNumber]);
    notifyListeners();
  }
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (context) => LedPinLevelStore(),
        child: HomePage()
      )
    ); 
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("LED Level"),
              Text("上段"),
              LedCheckBoxesContainer(),
              Divider(),
              Text("中段"),
              LedCheckBoxesContainer(),
              Divider(),
              Text("下段"),
              LedCheckBoxesContainer()
            ],
          ),
        )
    );
  }
}


class LedCheckBoxesContainer extends StatefulWidget {
  @override
  _LedCheckBoxesContainerState createState() => _LedCheckBoxesContainerState();
}

class _LedCheckBoxesContainerState extends State<LedCheckBoxesContainer> {
  List<List<int>> leddata = List<List<int>>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              print(index);
              index = index * 3;
              return Row(
                children: [
                  Checkbox(
                    value: context.select((LedPinLevelStore store) => store.ledLevels[0][index]),
                    activeColor: Colors.red,
                    onChanged: (f) {
                      context.read<LedPinLevelStore>()
                      .changePinLevel(cathodeNumber: 0, anodeNumber: index, anodeLevel: f);
                    },
                  ),
                  Checkbox(
                    value: context.select((LedPinLevelStore store) => store.ledLevels[0][index + 1]),
                    activeColor: Colors.red,
                    onChanged: (f) {
                      context.read<LedPinLevelStore>()
                      .changePinLevel(cathodeNumber: 0, anodeNumber: index + 1, anodeLevel: f);
                    },
                  ),
                  Checkbox(
                    value: context.select((LedPinLevelStore store) => store.ledLevels[0][index + 2]),
                    activeColor: Colors.red,
                    onChanged: (f) {
                      context.read<LedPinLevelStore>()
                      .changePinLevel(cathodeNumber: 0, anodeNumber: index + 2, anodeLevel: f);
                    },
                  )
                ],
              );
            }
          )
        ]
      ),
    );
  }
}

