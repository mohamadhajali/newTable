import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_table/component/table_component.dart';
import 'package:pluto_grid/pluto_grid.dart';

void main() {
  runApp(
    const Directionality(
      textDirection: TextDirection.rtl,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  double height = 0;
  final List<String> arabicExpenseNames = [
    'تكاليف الإيجار',
    'مصاريف الموظفين',
    'مصاريف الصيانة',
    'تكاليف الإنتاج',
    'مصاريف الشحن',
    'تكاليف التسويق',
    'مصاريف السفر',
    'تكاليف الطباعة',
    'مصاريف التأمين',
    'تكاليف الإنترنت',
    'مصاريف الهاتف',
    'تكاليف البنزين',
    'مصاريف الضرائب',
    'تكاليف الكهرباء',
    'مصاريف الماء',
    'تكاليف الأدوات المكتبية',
    'مصاريف التصميم',
    'تكاليف التطوير',
    'مصاريف النقل',
    'تكاليف الطعام',
    // Add more expense names as needed
  ];
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

  List<PlutoColumnGroup> columnGroups = [];

  List<PlutoColumn> polCol = [];
  List<PlutoRow> polRows = [];
  @override
  void didChangeDependencies() {
    polCol.addAll([
      PlutoColumn(
        frozen: PlutoColumnFrozen.start,
        width: 50,
        title: '',
        field: 'column2',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        frozen: PlutoColumnFrozen.start,
        width: 50,
        title: '',
        field: 'column3',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        width: 50,
        title: '',
        frozen: PlutoColumnFrozen.start,
        field: 'column4',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        width: 50,
        title: '',
        frozen: PlutoColumnFrozen.start,
        field: 'column5',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'النفقات',
        frozen: PlutoColumnFrozen.start,
        field: 'column6',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        field: 'usd',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils1',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        field: 'usd1',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        enableEditingMode: true,
        field: 'ils2',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        enableEditingMode: true,
        field: 'usd2',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils3',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        enableEditingMode: true,
        field: 'usd3',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        enableEditingMode: true,
        field: 'ils4',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        enableEditingMode: true,
        title: 'الدولار',
        field: 'usd4',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        enableEditingMode: true,
        field: 'ils5',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        enableEditingMode: true,
        field: 'usd5',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        enableEditingMode: true,
        title: 'الشيكل',
        field: 'ils6',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        field: 'usd6',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils7',
        type: PlutoColumnType.text(),
        enableEditingMode: true,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        field: 'usd7',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils8',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        field: 'usd8',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils9',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        enableEditingMode: true,
        field: 'usd9',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils10',
        type: PlutoColumnType.text(),
        enableEditingMode: true,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        field: 'usd10',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
        enableEditingMode: true,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils11',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        enableEditingMode: true,
        field: 'usd11',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils12',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        field: 'usd12',
        enableEditingMode: true,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الشيكل',
        field: 'ils13',
        type: PlutoColumnType.text(),
        enableEditingMode: true,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'الدولار',
        field: 'usd13',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
        enableEditingMode: true,
      ),
    ]);

    // columnGroups.addAll([
    //   PlutoColumnGroup(
    //     title: 'التقييم الاقتصادري',
    //     fields: ['column2', 'column3', 'column4', 'column5', "column6"],
    //   ),
    //   PlutoColumnGroup(title: "إلاجمالي", fields: ['ils,usd'],),
    // ]);
    columnGroups.addAll([
      PlutoColumnGroup(
        title: 'التقييم الاقتصادي',
        // backgroundColor: Colors.teal,
        fields: ['column2', 'column3', 'column4', 'column5', "column6"],
        // children: [
        //   PlutoColumnGroup(
        //     title: 'A - 1',
        //     fields: ['column2', 'column3'],
        //     backgroundColor: Colors.amber,
        //   ),
        //   PlutoColumnGroup(
        //     title: 'A - 2',
        //     backgroundColor: Colors.greenAccent,
        //     children: [
        //       PlutoColumnGroup(
        //         title: 'A - 2 - 1',
        //         fields: ['column4'],
        //       ),
        //       PlutoColumnGroup(
        //         title: 'A - 2 - 2',
        //         fields: ['column5'],
        //       ),
        //     ],
        //   ),
        // ],
      ),
      PlutoColumnGroup(
        title: 'الاجمالي',
        children: [
          PlutoColumnGroup(
            fields: ['ils', 'usd'],
            title: '',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'الشركة',
        children: [
          PlutoColumnGroup(
            fields: ['ils1', 'usd1'],
            title: '343',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 1',
        children: [
          PlutoColumnGroup(
            fields: ['ils2', 'usd2'],
            title: '1231',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 2',
        children: [
          PlutoColumnGroup(
            fields: ['ils3', 'usd3'],
            title: '213',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 3',
        children: [
          PlutoColumnGroup(
            fields: ['ils4', 'usd4'],
            title: '3123',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 4',
        children: [
          PlutoColumnGroup(
            fields: ['ils5', 'usd5'],
            title: '21',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 5',
        children: [
          PlutoColumnGroup(
            fields: ['ils6', 'usd6'],
            title: '213',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 6',
        children: [
          PlutoColumnGroup(
            fields: ['ils7', 'usd7'],
            title: '123',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 7',
        children: [
          PlutoColumnGroup(
            fields: ['ils8', 'usd8'],
            title: '3223',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 8',
        children: [
          PlutoColumnGroup(
            fields: ['ils9', 'usd9'],
            title: '7666',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 9',
        children: [
          PlutoColumnGroup(
            fields: ['ils10', 'usd10'],
            title: '66788',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 10',
        children: [
          PlutoColumnGroup(
            fields: ['ils11', 'usd11'],
            title: '9877',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 11',
        children: [
          PlutoColumnGroup(
            fields: ['ils12', 'usd12'],
            title: '8787',
          ),
        ],
      ),
      PlutoColumnGroup(
        title: 'فرع 12',
        children: [
          PlutoColumnGroup(
            fields: ['ils13', 'usd13'],
            title: '3123',
          ),
        ],
      ),
    ]);
    _fillWithData();
    // _fillColumnGroupTitles();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _fillColumnGroupTitles() {
    final Random random = Random();

    setState(() {
      // Create a new list to store updated column groups
      List<PlutoColumnGroup> updatedColumnGroups = [];

      for (var group in columnGroups) {
        // Check if the group title is empty
        if (group.hasChildren) {
          for (int i = 0; i < group.children!.length; i++) {
            if (group.children![i].title.isEmpty) {
              final int branchCode = 1000 + random.nextInt(9000);
              PlutoColumnGroup updatedGroup = PlutoColumnGroup(
                title: 'Branch $branchCode',
                fields: group.fields,
                children: group.children,
              );
              group.children!.removeAt(i);
              group.children!.add(updatedGroup);
              setState(() {});
            }
          }
        }
        // if (group.title.isEmpty) {
        //   // Generate a random branch code between 1000 and 9999
        //   final int branchCode = 1000 + random.nextInt(9000);
        //   // Create a new column group with the random branch code as title
        //   PlutoColumnGroup updatedGroup = PlutoColumnGroup(
        //     title: 'Branch $branchCode',
        //     fields: group.fields,
        //     children: group.children,
        //   );
        //   updatedColumnGroups.add(updatedGroup);
        // } else {
        //   // If the title is not empty, keep the existing column group
        //   updatedColumnGroups.add(group);
        // }
      }

      // Update the original columnGroups list with the new list
      // columnGroups = updatedColumnGroups;

      // Print the updated titles for debugging
      print('Updated Column Group Titles:');
      for (var group in columnGroups) {
        print(group.title);
      }
    });
  }

  void _fillWithData() {
    final Random random = Random();
    int count = 0;
    setState(() {
      polRows = List.generate(100, (index) {
        final int randomIndex = random.nextInt(arabicExpenseNames.length);
        final int sectionNumber = index ~/ 10 + 1;
        final int rowInSection = index % 10 + 1;
        if (rowInSection == 10) {
          count = 0;
        }
        final String value1 = (rowInSection == 1) ? '$sectionNumber' : '';

        final String value2 =
            (rowInSection == 2) ? '$sectionNumber$sectionNumber' : '';
        final String value3 =
            (rowInSection == 3) ? '$sectionNumber${rowInSection - 1}' : '';
        final String value4 =
            (rowInSection >= 4) ? '$sectionNumber${count++}' : '';
        return PlutoRow(
          cells: {
            'column2': PlutoCell(value: value1),
            'column3': PlutoCell(value: value2),
            'column4': PlutoCell(value: value3),
            'column5': PlutoCell(value: value4),
            'column6': PlutoCell(
                value: sectionNumber == 1 && rowInSection == 1
                    ? "النفقات"
                    : arabicExpenseNames[randomIndex]),
            'ils': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils1': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd1': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils2': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd2': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils3': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd3': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils4': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd4': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils5': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd5': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils6': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd6': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils7': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd7': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils8': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd8': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils9': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd9': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils10': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd10': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils11': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd11': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils12': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd12': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'ils13': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
            'usd13': PlutoCell(
                value: (random.nextDouble() * 100).toStringAsFixed(2)),
          },
        );
      });
    });
    // polRows.insert(
    //     0,
    //     PlutoRow(
    //       cells: {
    //         'column2': PlutoCell(value: ''),
    //         'column3': PlutoCell(value: ''),
    //         'column4': PlutoCell(value: ''),
    //         'column5': PlutoCell(value: ''),
    //         'column6': PlutoCell(value: "النفقات"),
    //         'ils': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils1': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd1': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils2': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd2': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils3': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd3': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils4': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd4': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils5': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd5': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils6': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd6': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils7': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd7': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils8': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd8': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils9': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd9': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils10': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd10': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils11': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd11': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils12': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd12': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'ils13': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //         'usd13': PlutoCell(
    //             value: (random.nextDouble() * 100).toStringAsFixed(2)),
    //       },
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    height = MediaQuery.of(context).size.height;

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
      body: SizedBox(
        height: height * 0.79,
        child: TableComponent(
          mode: PlutoGridMode.normal,
          plCols: polCol,
          columnGroups: columnGroups,
          polRows: polRows,
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
