import 'package:dining_menu/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    //title: title,
    theme: ThemeData(
      primaryColor: Colors.redAccent,
    ),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //DataController dataController = Get.put(DataController());

  @override
  void initState() {
    //getData('ALL');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dining Menu Finder'),
        backgroundColor: Color.fromRGBO(226, 23, 53, 1),
        leading: IconButton(
            icon: Image.asset('images/umd_logo.png'),
            onPressed: () => {},
          ),
        actions: [

          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              handleSearch(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              onAlertWithCustomContentPressed(context);
            },
          ),
          ],
        ),
      body: GestureDetector(
        onTap: () async {
          handleSearch(context);
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("images/umd_dining.png"),
              //image: AssetImage("images/feed_turtle.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: MenuPage(),
          ),
      ),
    );
  }

}

void handleSearch(context) async {
  //showSearch(context: context, delegate: MenuSearch());
  final results = await
  showSearch(context: context, delegate: MenuSearch());

  //print('Result: $results');
}

void handleClick(String value) {
  switch (value) {
    case 'About':
      break;
    case 'UMD Dining':
      break;
  }
}

// Alert custom content
onAlertWithCustomContentPressed(context) {
  Alert(
    context: context,
    title: "About",
    content: Column(
      children: const [
        Text('\nThis app was developed by Andy Diep while studying CS and ACES Honors LLP at UMD College Park (Class of 2026).\n\nContact adiep@umd.edu for feedback and/or suggestions.',
          style: TextStyle(color: Colors.black45, fontSize: 18)
        ),
        Text('\nGo TERPS!',
            style: TextStyle(color: Colors.redAccent, fontSize: 18)
        ),
      ],
    ),
    buttons: [
      DialogButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close',
            style: TextStyle(color: Colors.black, fontSize: 18)
        ),
        color: Color.fromRGBO(226, 23, 53, 1),
      ),
    ],
  ).show();
}


