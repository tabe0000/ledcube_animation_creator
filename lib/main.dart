import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:clippy/browser.dart' as clippy;

class LedPinLevelStore with ChangeNotifier {
  List<List<bool>> ledLevels = [
    List.generate(9, (index) => false),
    List.generate(9, (index) => false),
    List.generate(9, (index) => false)
  ];

  String exportedCode = "[[false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false]]";

  void generateCode() {
    exportedCode = ledLevels.toString();
  }

  void changePinLevel ({int cathodeNumber, int anodeNumber, bool anodeLevel}) {
    ledLevels[cathodeNumber][anodeNumber] = anodeLevel;
    generateCode();
    notifyListeners();
  }

  void allLevelLow() {
    for(int i = 0; i < ledLevels.length; i++) {
      for (int j = 0; j < ledLevels[i].length; j++) {
        ledLevels[i][j] = false;
      }
    }
    generateCode();
    notifyListeners();
  }

  void allLevelHigh() {
    for(int i = 0; i < ledLevels.length; i++) {
      for (int j = 0; j < ledLevels[i].length; j++) {
        ledLevels[i][j] = true; 
      }
    }
    generateCode();
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
      title: 'Led Pattern Code Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
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
      appBar: AppBar(
        title: Text("Led Pattern Code Generator"),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(100),
                    child: Column(
                      children: [
                        Text(
                          "LED Level",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(height: 20,),
                        Text("上段"),
                        LedCheckBoxesContainer(0),
                        Divider(),
                        Text("中段"),
                        LedCheckBoxesContainer(1),
                        Divider(),
                        Text("下段"),
                        LedCheckBoxesContainer(2),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              child: Text('all high'),
                              onPressed: () => context.read<LedPinLevelStore>().allLevelHigh(),
                            ),
                            SizedBox(width: 20,),
                            RaisedButton(
                              child: Text('all low'),
                              onPressed: () => context.read<LedPinLevelStore>().allLevelLow()
                            )
                          ]
                        )
                      ],
                    )),
                  Padding(
                    padding: EdgeInsets.all(100),
                    child: Column(
                      children:[
                        Text(
                          'Exported Code',
                          style: Theme.of(context).textTheme.headline4),
                        Divider(),
                        RaisedButton(
                          onPressed: () async {
                            await clippy.write(context.read<LedPinLevelStore>().exportedCode);
                          },
                          child: Text("Copy!!!!"),
                        ),
                        SizedBox(height: 20,),
                        SelectableText(
                          context.select((LedPinLevelStore store) => store.exportedCode)
                        ),
                      ]
                    ),
                  )
                ],
              ),
          ),
        )
    );
  }
}


class LedCheckBoxesContainer extends StatefulWidget {
  int cathodeNumber;
  LedCheckBoxesContainer(this.cathodeNumber) : assert(cathodeNumber != null);
  @override
  _LedCheckBoxesContainerState createState() => _LedCheckBoxesContainerState();
}

class _LedCheckBoxesContainerState extends State<LedCheckBoxesContainer> {
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
              index = index * 3;
              return Row(
                children: [
                  Checkbox(
                    value: context.select((LedPinLevelStore store) => store.ledLevels[widget.cathodeNumber][index]),
                    activeColor: Colors.red,
                    onChanged: (f) {
                      context.read<LedPinLevelStore>()
                      .changePinLevel(cathodeNumber: widget.cathodeNumber, anodeNumber: index, anodeLevel: f);
                    },
                  ),
                  Checkbox(
                    value: context.select((LedPinLevelStore store) => store.ledLevels[widget.cathodeNumber][index + 1]),
                    activeColor: Colors.red,
                    onChanged: (f) {
                      context.read<LedPinLevelStore>()
                      .changePinLevel(cathodeNumber: widget.cathodeNumber, anodeNumber: index + 1, anodeLevel: f);
                    },
                  ),
                  Checkbox(
                    value: context.select((LedPinLevelStore store) => store.ledLevels[widget.cathodeNumber][index + 2]),
                    activeColor: Colors.red,
                    onChanged: (f) {
                      context.read<LedPinLevelStore>()
                      .changePinLevel(cathodeNumber: widget.cathodeNumber, anodeNumber: index + 2, anodeLevel: f);
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

