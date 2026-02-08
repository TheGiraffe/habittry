import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String user = "User";

    return MaterialApp(
      title: 'Habittry',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.pink),
      ),
      home: const MyHomePage(title: user + "'s habittry"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CreateHabitForm(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateHabitForm extends StatefulWidget {
  const CreateHabitForm({super.key});
  @override
  State<CreateHabitForm> createState() => _CreateHabitFormState();
}

class _CreateHabitFormState extends State<CreateHabitForm> {
  String _habitName = "";
  String? _habitFrequency;
  int? _habitFrequencyNum;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'New Habit: $_habitName',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Habit Title"),
              onChanged: (String? value) {
                _habitName = '$value';
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Select Habit Frequency"),
              onChanged: (value) {
                setState(() {
                  _habitFrequency = '$value';
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a frequency';
                }
                return null;
              },
              initialValue: _habitFrequency,
              items: ['Daily', 'Weekly', 'Monthly']
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
            ),
            _habitFrequency == 'Daily'
                ? DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "How Many Times Per Day?",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _habitFrequencyNum = int.parse('$value');
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a daily frequency';
                      }
                      return null;
                    },
                    initialValue: _habitFrequencyNum,
                    items: [1, 2, 3]
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text('$option'),
                          ),
                        )
                        .toList(),
                  )
                : Container(),
            _habitFrequency == 'Weekly'
                ? DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "How Many Times Per Week?",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _habitFrequencyNum = int.parse('$value');
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a weekly frequency';
                      }
                      return null;
                    },
                    initialValue: _habitFrequencyNum,
                    items: [1, 2, 3, 4, 5, 6, 7]
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text('$option'),
                          ),
                        )
                        .toList(),
                  )
                : Container(),
            _habitFrequency == 'Monthly'
                ? DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "How Many Times Per Month?",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _habitFrequencyNum = int.parse('$value');
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a monthly frequency';
                      }
                      return null;
                    },
                    initialValue: _habitFrequencyNum,
                    items: [1, 2, 3, 4, 5]
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text('$option'),
                          ),
                        )
                        .toList(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
