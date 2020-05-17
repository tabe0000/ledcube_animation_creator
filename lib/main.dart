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

  void changePinLevel ({int cathodeNumber, int anodeNumber, bool anodeLevel}) {
    ledLevels[cathodeNumber][anodeNumber] = anodeLevel;
    notifyListeners();
  }

  void allLevelLow() {
    for(int i = 0; i < ledLevels.length; i++) {
      for (int j = 0; j < ledLevels[i].length; j++) {
        ledLevels[i][j] = false;
      }
    }
    notifyListeners();
  }

  void allLevelHigh() {
    for(int i = 0; i < ledLevels.length; i++) {
      for (int j = 0; j < ledLevels[i].length; j++) {
        ledLevels[i][j] = true; 
      }
    }
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
                            print("clicked");
                            await clippy.write('copied clip');
                          },
                          child: Text("Copy!!!!"),
                        ),
                        SizedBox(height: 20,),
                        SelectableText(
                          "慶応3年1月5日（新暦2月9日）江戸牛込馬場下横町に生まれる。本名は夏目金之助。帝国大学文科大学（東京大学文学部）を卒業後、東京高等師範学校、松山中学、第五高等学校などの教師生活を経て、1900年イギリスに留学する。帰国後、第一高等学校で教鞭をとりながら、1905年処女作「吾輩は猫である」を発表。1906年「坊っちゃん」「草枕」を発表。1907年教職を辞し、朝日新聞社に入社。そして「虞美人草」「三四郎」などを発表するが、胃病に苦しむようになる。1916年12月9日、「明暗」の連載途中に胃潰瘍で永眠。享年50歳であった。"
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

