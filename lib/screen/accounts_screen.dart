import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:new_table/component/table_component.dart';
import 'package:new_table/controllers/account_controller.dart';
import 'package:new_table/models/tree_account.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _counter = 0;
  double height = 0;
  double width = 0;
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

  int maxLevel = 0;
  List<PlutoColumnGroup> columnGroups = [];
  late PlutoGridStateManager stateManager;
  List<PlutoColumn> polCol = [];
  List<PlutoRow> polRows = [];
  int numOfBranch = 0;
  @override
  void didChangeDependencies() async {
    fillColumn();
    // _fillWithData();
    Future.delayed(const Duration(milliseconds: 1), () async {
      await getAccount();
    });
    // _fillColumnGroupTitles();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  ValueNotifier isLoading = ValueNotifier(false);
  bool isLoading2 = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        TableComponent(
          onLoaded: (event) {
            stateManager = event.stateManager;
            // stateManager.columns[0].title = "s";
          },
          mode: PlutoGridMode.normal,
          plCols: polCol,
          columnGroups: columnGroups,
          polRows: polRows,
          onChange: (event) {
            // getTotals();
            getTotalRows(event.rowIdx);

            // if (event.column.field.contains('usd')) {
            //   chnageFromUSDToILS(event);
            // } else if (event.column.field.contains('ils')) {
            //   changeFromILSToUSD(event);
            // }
          },
        ),
        Visibility(
          visible: isLoading2,
          child: Container(
            color: Colors.black.withOpacity(
                0.08), // Semi-transparent black background for the blur effect
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 2.0, sigmaY: 2.0), // Adjust the blur amount as needed
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Loading...")
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void getTotalRows(int i) {
    // Initialize totals for ils and usd to 0
    double totalIls = 0;
    double totalUsd = 0;

    // Loop through the branches and sum up the values for ils and usd
    for (int j = 0; j < numOfBranch; j++) {
      totalIls += double.parse(polRows[i].cells['ils$j']!.value.toString());
      totalUsd += double.parse(polRows[i].cells['usd$j']!.value.toString());
    }

    // Set the totals in the main row
    polRows[i].cells['ils']!.value = totalIls;
    polRows[i].cells['usd']!.value = totalUsd;

    // Traverse upwards to calculate parent sums
    int startIndexForSumLevel1 = 0;
    for (int j = i; j < polRows.length; j++) {
      if (polRows[j].cells['txtTreenode']!.value !=
          polRows[i].cells['txtTreenode']!.value) {
        startIndexForSumLevel1 = j - 1;
        break;
      }
    }
    for (int j = i - 1; j >= 0; j--) {
      if (polRows[j].cells['bolIsparent']!.value == 1) {
        double parentTotalIls = 0;
        double parentTotalUsd = 0;

        // Loop through the children of the parent and calculate the sum
        for (int k = j + 1; k <= startIndexForSumLevel1; k++) {
          if (polRows[k].cells['bolIsparent']!.value != 1 &&
              polRows[k].cells['txtParentcode']!.value ==
                  polRows[j].cells['txtCode']!.value) {
            // Ensure child's parent code matches current parent's code
            parentTotalIls +=
                double.parse(polRows[k].cells['ils']!.value.toString());
            parentTotalUsd +=
                double.parse(polRows[k].cells['usd']!.value.toString());
          }
        }

        // Set the sum in the parent row
        polRows[j].cells['ils']!.value = parentTotalIls;
        polRows[j].cells['usd']!.value = parentTotalUsd;
      }
    }

    // Calculate sum of non-parent rows for the current account
    double sumIls = 0;
    double sumUsd = 0;

    for (int j = 0; j < polRows.length; j++) {
      if (polRows[j].cells['bolIsparent']!.value != 1 &&
          polRows[j].cells['txtTreenode']!.value ==
              polRows[i].cells['txtTreenode']!.value) {
        // Ensure child's tree node matches current node
        sumIls += double.parse(polRows[j].cells['ils']!.value.toString());
        sumUsd += double.parse(polRows[j].cells['usd']!.value.toString());
      }
    }

    // Set the sum in the parent row if it's a level 1 account
    // if (polRows[i].cells['intLevel']!.value == 1) {
    //   for (int j = 0; j < polRows.length; j++) {
    //     if (polRows[j].cells['bolIsparent']!.value == 1 &&
    //         polRows[j].cells['txtTreenode']!.value ==
    //             polRows[i].cells['txtTreenode']!.value) {
    //       // Ensure parent's tree node matches current node
    //       polRows[j].cells['ils']!.value = sumIls;
    //       polRows[j].cells['usd']!.value = sumUsd;
    //       break;
    //     }
    //   }
    // }
    getTotalsForLevel1(i);

    // Initialize totals for ils and usd to 0
    //////////////
    // for (int j = i; j >= 0; j--) {
    //   if (polRows[j].cells['bolIsparent']!.value == 1) {
    //     double parentTotalIls = 0;
    //     double parentTotalUsd = 0;

    //     // Loop through the children of the parent and calculate the sum
    //     for (int k = j + 1; k <= i; k++) {
    //       if (polRows[k].cells['bolIsparent']!.value != 1) {
    //         parentTotalIls +=
    //             double.parse(polRows[k].cells['ils']!.value.toString());
    //         parentTotalUsd +=
    //             double.parse(polRows[k].cells['usd']!.value.toString());
    //       }
    //     }

    //     // Set the sum in the parent row
    //     polRows[j].cells['ils']!.value = parentTotalIls;
    //     polRows[j].cells['usd']!.value = parentTotalUsd;
    //   }
    // }
  }

  getTotalsForLevel1(int i) {
    double totalIls = 0;
    double totalUsd = 0;
    // Loop through the branches and sum up the values for ils and usd
    for (int j = 0; j < numOfBranch; j++) {
      totalIls += double.parse(polRows[i].cells['ils$j']!.value.toString());
      totalUsd += double.parse(polRows[i].cells['usd$j']!.value.toString());
    }
    // Set the totals in the main row
    polRows[i].cells['ils']!.value = totalIls;
    polRows[i].cells['usd']!.value = totalUsd;

    // Find the sum of non-parent accounts for the current account's "txtTreenode"
    double treeNodeSumIls = 0;
    double treeNodeSumUsd = 0;
    int startIndexForSumLevel1 = 0;
    for (int j = i; j < polRows.length; j++) {
      if (polRows[j].cells['txtTreenode']!.value !=
          polRows[i].cells['txtTreenode']!.value) {
        startIndexForSumLevel1 = j;
        break;
      }
    }
    for (int k = startIndexForSumLevel1; k >= 0; k--) {
      if (polRows[k].cells['txtTreenode']!.value ==
              polRows[i].cells['txtTreenode']!.value &&
          polRows[k].cells['bolIsparent']!.value != 1) {
        treeNodeSumIls +=
            double.parse(polRows[k].cells['ils']!.value.toString());
        treeNodeSumUsd +=
            double.parse(polRows[k].cells['usd']!.value.toString());
      }
    }
    print(4);

    // Set the sum in the parent row at level 1

    for (int j = i; j >= 0; j--) {
      if (polRows[j].cells['intLevel']!.value == 1) {
        polRows[j].cells['ils']!.value = treeNodeSumIls;
        polRows[j].cells['usd']!.value = treeNodeSumUsd;
        break;
      }
    }
  }

  getTotals() {
    for (int i = 0; i < polRows.length; i++) {
      for (int j = 0; j < numOfBranch; j++) {
        polRows[i].cells['ils']!.value +=
            double.parse(polRows[i].cells['ils$j']!.value.toString());
        polRows[i].cells['usd']!.value +=
            double.parse(polRows[i].cells['usd$j']!.value.toString());
      }
    }
  }

  Widget currencyRenderer(PlutoColumnRendererContext ctx) {
    assert(ctx.column.type.isCurrency);

    Color color = Colors.black;

    if (ctx.cell.value > 0) {
      color = Colors.black;
    } else if (ctx.cell.value < 0) {
      color = Colors.red;
    }

    return Text(
      ctx.column.type.applyFormat(ctx.cell.value),
      style: TextStyle(color: color),
      textAlign: TextAlign.center,
    );
  }

  changeFromILSToUSD(PlutoGridOnChangedEvent event) {
    if (event.column.field == "ils") {
      event.row.cells['usd']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils1") {
      event.row.cells['usd1']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils2") {
      event.row.cells['usd2']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils3") {
      event.row.cells['usd3']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils4") {
      event.row.cells['usd4']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils5") {
      event.row.cells['usd5']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils6") {
      event.row.cells['usd6']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils7") {
      event.row.cells['usd7']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils8") {
      event.row.cells['usd8']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils9") {
      event.row.cells['usd9']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils10") {
      event.row.cells['usd10']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils11") {
      event.row.cells['usd11']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils12") {
      event.row.cells['usd12']!.value =
          double.parse(event.value.toString()) / usdPer;
    } else if (event.column.field == "ils13") {
      event.row.cells['usd13']!.value =
          double.parse(event.value.toString()) / usdPer;
    }
    getTotals();
    setState(() {});
  }

  chnageFromUSDToILS(PlutoGridOnChangedEvent event) {
    if (event.column.field == "usd") {
      event.row.cells['ils']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd1") {
      event.row.cells['ils1']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd2") {
      event.row.cells['ils2']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd3") {
      event.row.cells['ils3']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd4") {
      event.row.cells['ils4']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd5") {
      event.row.cells['ils5']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd6") {
      event.row.cells['ils6']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd7") {
      event.row.cells['ils7']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd8") {
      event.row.cells['ils8']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd9") {
      event.row.cells['ils9']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd10") {
      event.row.cells['ils10']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd11") {
      event.row.cells['ils11']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd12") {
      event.row.cells['ils12']!.value =
          double.parse(event.value.toString()) * usdPer;
    } else if (event.column.field == "usd13") {
      event.row.cells['ils13']!.value =
          double.parse(event.value.toString()) * usdPer;
    }
    getTotals();
    setState(() {});
    // polRows[event.rowIdx].cells.;
  }

  String formatDouble(double value) {
    // Format the value with two decimal places
    String formattedValue = value.toStringAsFixed(2);

    // Split the value into parts before and after the decimal point
    List<String> parts = formattedValue.split('.');
    String beforeDecimal = parts[0];
    String afterDecimal = parts.length > 1 ? parts[1] : "";

    // Add commas to the part before the decimal point
    String formattedBeforeDecimal = "";
    for (int i = beforeDecimal.length - 1; i >= 0; i--) {
      formattedBeforeDecimal = beforeDecimal[i] + formattedBeforeDecimal;
      if ((beforeDecimal.length - i) % 3 == 0 && i > 0) {
        formattedBeforeDecimal = ',$formattedBeforeDecimal';
      }
    }

    // Combine the parts with a decimal point
    String formattedValueWithCommas = formattedBeforeDecimal +
        (afterDecimal.isEmpty ? "" : ".") +
        afterDecimal;

    return formattedValueWithCommas;
  }

  PlutoRow _generateSumRow(List<PlutoRow> rows) {
    Map<String, PlutoCell> sumCells = {};
    // Iterate through each row and sum up the values in each cell
    rows.forEach((row) {
      row.cells.forEach((key, cell) {
        if (sumCells.containsKey(key)) {
          double sum = double.tryParse(sumCells[key]!.value.toString()) ?? 0;
          double value = double.tryParse(cell.value.toString()) ?? 0;
          sum += value;
          sumCells[key] = PlutoCell(value: sum.toStringAsFixed(2));
        } else {
          sumCells[key] = PlutoCell(value: cell.value);
        }
      });
    });

    // Create the sum row using the calculated sum values
    Map<String, PlutoCell> cells = {};
    sumCells.forEach((key, cell) {
      cells[key] = cell;
    });

    return PlutoRow(cells: cells);
  }

  // void _fillWithData() {
  //   final Random random = Random();
  //   int count = 0;
  //   polRows = List.generate(100, (index) {
  //     final int randomIndex = random.nextInt(arabicExpenseNames.length);
  //     final int sectionNumber = index ~/ 10 + 1;
  //     final int rowInSection = index % 10 + 1;
  //     if (rowInSection > 10) {
  //       count = 0;
  //     }

  //     final String value1 = (rowInSection == 1) ? '$sectionNumber' : '';
  //     final String value2 =
  //         (rowInSection == 2) ? '$sectionNumber$sectionNumber' : '';
  //     final String value3 =
  //         (rowInSection == 3) ? '$sectionNumber${rowInSection - 1}' : '';
  //     final String value4 =
  //         (rowInSection >= 4) ? '$sectionNumber${count++}' : '';

  //     return PlutoRow(
  //       cells: {
  //         'column2': PlutoCell(value: value1),
  //         'column3': PlutoCell(value: value2),
  //         'column4': PlutoCell(value: value3),
  //         'column5': PlutoCell(value: value4),
  //         'column6': PlutoCell(
  //             value: sectionNumber == 1 && rowInSection == 1
  //                 ? "النفقات"
  //                 : arabicExpenseNames[randomIndex]),
  //         'ils':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils1':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd1':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils2':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd2':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils3':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd3':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils4':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd4':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils5':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd5':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils6':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd6':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils7':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd7':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils8':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd8':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils9':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd9':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils10':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd10':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils11':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd11':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils12':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd12':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'ils13':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //         'usd13':
  //             PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2)),
  //       },
  //     );
  //   });
  //   List<PlutoRow> updatedRows = [];
  //   for (int i = 0; i < polRows.length; i++) {
  //     updatedRows.add(polRows[i]);
  //     if ((i + 1) % 10 == 0) {
  //       updatedRows.add(_generateSumRow(polRows.sublist(i - 9, i + 1)));
  //     }
  //   }
  //   polRows = updatedRows;
  // }

  getAccount() async {
    // stateManager.setShowLoading(true);
    // isLoading.value = true;
    setState(() {
      isLoading2 = true;
    });
    await AccountController().getAllAccount().then((value) {
      print("length ${value.length}");

      maxLevel = getMaxLevel(value);
      for (int i = 1; i <= maxLevel; i++) {
        stateManager.insertColumns(i - 1, [
          PlutoColumn(
            title: 'Level $i',
            field: 'column$i',
            type: PlutoColumnType.text(),
            width: 100,
            titleTextAlign: PlutoColumnTextAlign.center,
            frozen: PlutoColumnFrozen.start,
            readOnly: true,
            renderer: (rendererContext) {
              return Tooltip(
                message: rendererContext.cell.value.toString(),
                child: Text(rendererContext.cell.value.toString()),
              );
            },
          )
        ]);
      }
      numOfBranch = value[0].branches!.length;
      for (int i = 0; i < numOfBranch; i++) {
        stateManager.insertColumns(stateManager.columns.length, [
          PlutoColumn(
            title: 'الدولار',
            field: 'usd$i',
            enableEditingMode: true,
            type: PlutoColumnType.currency(
              name: '',
              decimalDigits: 3,
              // negative: false,
            ),
            renderer: currencyRenderer,
            checkReadOnly: (row, cell) {
              return row.cells['bolIsparent']!.value == 1 ? true : false;
            },
            titleTextAlign: PlutoColumnTextAlign.center,
            footerRenderer: (rendererContext) {
              return PlutoAggregateColumnFooter(
                rendererContext: rendererContext,
                type: PlutoAggregateColumnType.sum,
                format: '#',
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  // double sum = 0;
                  // for (int i = 0; i < polRows.length; i++) {
                  //   sum += double.parse(
                  //       polRows[i].cells['usd1']!.value.toString());
                  // }
                  return [
                    TextSpan(
                        text: "${formatDouble(double.parse(text))} USD",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontSize: 18,
                          color: Colors.black,
                        )),
                  ];
                },
              );
            },
          ),
          PlutoColumn(
            title: 'الشيكل',
            field: 'ils$i',
            enableEditingMode: true,
            type: PlutoColumnType.currency(
              name: '',
              decimalDigits: 3,
              // negative: false,
            ),
            checkReadOnly: (row, cell) {
              return row.cells['bolIsparent']!.value == 1 ? true : false;
            },
            renderer: currencyRenderer,
            titleTextAlign: PlutoColumnTextAlign.center,
            footerRenderer: (rendererContext) {
              return PlutoAggregateColumnFooter(
                rendererContext: rendererContext,
                type: PlutoAggregateColumnType.sum,
                format: '#',
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    TextSpan(
                        text: "${formatDouble(double.parse(text))} USD",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ];
                },
              );
            },
          ),
        ]);
        columnGroups.add(
          PlutoColumnGroup(
            title: value[0].branches![i].txtName,
            children: [
              PlutoColumnGroup(
                fields: ['ils$i', 'usd$i'],
                title: value[0].branches![i].txtCode,
              ),
            ],
          ),
        );
      }
      print("111111");
      populateRows(value, polRows, maxLevel);
      // isLoading.value = false;
      getTotals();

      setState(() {
        isLoading2 = false;
      });
      // stateManager.setShowLoading(false);

      print("222");
    });
  }

  int getMaxLevel(List<TreeAccount> treeAccounts) {
    int maxLevel = 0;
    for (var account in treeAccounts) {
      maxLevel = max(maxLevel, account.account!.intLevel);
      if (account.children!.isNotEmpty) {
        int childMaxLevel = getMaxLevel(account.children!);
        maxLevel = max(maxLevel, childMaxLevel);
      }
    }

    return maxLevel;
  }

  void populateRows(
      List<TreeAccount> treeAccounts, List<PlutoRow> rows, int maxLevel) {
    for (var account in treeAccounts) {
      // Initialize cells map
      Map<String, PlutoCell> cells = {};
      for (int i = 1; i <= maxLevel; i++) {
        cells['column$i'] = PlutoCell(value: '');
      }
      // Populate cells for each level with the English name of the account
      cells['column${account.account!.intLevel}'] =
          PlutoCell(value: account.account!.txtEnglishname);

      // Add random values for ils and usd columns
      cells['ils'] = PlutoCell(value: "0");
      cells['usd'] = PlutoCell(value: "0");

      // Add remaining cells with random values
      for (int i = 0; i < account.branches!.length; i++) {
        cells['ils$i'] =
            PlutoCell(value: formatDouble(account.branches![i].ils));
        cells['usd$i'] =
            PlutoCell(value: formatDouble(account.branches![i].dollar));
      }
      cells['bolIsparent'] = PlutoCell(value: account.account!.bolIsparent);
      cells['intLevel'] = PlutoCell(value: account.account!.intLevel);
      cells['txtParentcode'] = PlutoCell(value: account.account!.txtParentcode);
      cells['txtTreenode'] = PlutoCell(value: account.account!.txtTreenode);
      cells['txtCode'] = PlutoCell(value: account.account!.txtCode);
      // Add the populated row to the list
      // rows.add(PlutoRow(cells: cells));
      stateManager.appendRows([PlutoRow(cells: cells)]);
      // Process children accounts recursively
      if (account.children!.isNotEmpty) {
        populateRows(account.children!, rows, maxLevel);
      }
    }
  }
  /*
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
  */
  // stateManager.appendNewRows([PlutoRow(cells: cells)]);

  // List<PlutoRow> populateRows(List<TreeAccount> treeAccounts) {
  //   List<PlutoRow> rows = [];
  //   final Random random = Random();
  //   stateManager.setShowLoading(true);
  //   for (var treeAccount in treeAccounts) {
  //     var cells = <String, PlutoCell>{};
  //     // Populate first 5 cells
  //     // cells['column1'] = PlutoCell(
  //     //     value: treeAccount.account?.intLevel == 1
  //     //         ? treeAccount.account?.txtCode
  //     //         : '');
  //     switch (treeAccount.account!.intLevel) {
  //       case 1:
  //         stateManager.insertColumns(0, [
  //           PlutoColumn(
  //             readOnly: true,
  //             frozen: PlutoColumnFrozen.start,
  //             width: 50,
  //             title: '',
  //             field: 'column${treeAccount.account!.intLevel}',
  //             type: PlutoColumnType.text(),
  //             titleTextAlign: PlutoColumnTextAlign.center,
  //             renderer: (rendererContext) {
  //               return Tooltip(
  //                 message: rendererContext.cell.value.toString(),
  //                 child: Text(rendererContext.cell.value.toString()),
  //               );
  //             },
  //           )
  //         ]);

  //         // PlutoColumnGroup(
  //         //   title: 'التقييم الاقتصادي',
  //         //   // backgroundColor: Colors.teal,
  //         //   fields: ['column2', 'column3', 'column4', 'column5', "column6"],
  //         //   // children: [
  //         //   //   PlutoColumnGroup(
  //         //   //     title: 'A - 1',
  //         //   //     fields: ['column2', 'column3'],
  //         //   //     backgroundColor: Colors.amber,
  //         //   //   ),
  //         //   //   PlutoColumnGroup(
  //         //   //     title: 'A - 2',
  //         //   //     backgroundColor: Colors.greenAccent,
  //         //   //     children: [
  //         //   //       PlutoColumnGroup(
  //         //   //         title: 'A - 2 - 1',
  //         //   //         fields: ['column4'],
  //         //   //       ),
  //         //   //       PlutoColumnGroup(
  //         //   //         title: 'A - 2 - 2',
  //         //   //         fields: ['column5'],
  //         //   //       ),
  //         //   //     ],
  //         //   //   ),
  //         //   // ],
  //         // );
  //         cells['column${treeAccount.account!.intLevel}'] = PlutoCell(value: 1);
  //         // cells['column2'] = PlutoCell(value: '');
  //         // cells['column3'] = PlutoCell(value: '');
  //         // cells['column4'] = PlutoCell(value: '');
  //         // cells['column${treeAccount.account!.intLevel}'] =
  //         //     PlutoCell(value: treeAccount.account!.txtCode);
  //         // cells['column${treeAccount.account!.intLevel}'] =
  //         //     PlutoCell(value: treeAccount.account!.txtEnglishname);
  //         break;
  //     }
  //     // switch (treeAccount.account!.intLevel) {
  //     //   case 1:
  //     //     cells['column2'] = PlutoCell(value: treeAccount.account!.txtCode);
  //     //     cells['column3'] =
  //     //         PlutoCell(value: treeAccount.account!.txtEnglishname);
  //     //     cells['column4'] = PlutoCell(value: '');
  //     //     cells['column5'] = PlutoCell(value: '');
  //     //     cells['column6'] = PlutoCell(value: '');
  //     //   case 2:
  //     //     cells['column2'] = PlutoCell(value: '');
  //     //     cells['column3'] = PlutoCell(value: treeAccount.account!.txtCode);
  //     //     cells['column4'] =
  //     //         PlutoCell(value: treeAccount.account!.txtEnglishname);
  //     //     cells['column5'] = PlutoCell(value: '');
  //     //     cells['column6'] = PlutoCell(value: '');
  //     //     break;
  //     //   case 3:
  //     //     cells['column2'] = PlutoCell(value: '');
  //     //     cells['column3'] = PlutoCell(value: '');
  //     //     cells['column4'] = PlutoCell(value: treeAccount.account!.txtCode);
  //     //     cells['column5'] =
  //     //         PlutoCell(value: treeAccount.account!.txtEnglishname);
  //     //     cells['column6'] = PlutoCell(value: '');
  //     //     break;
  //     //   case 4:
  //     //     cells['column2'] = PlutoCell(value: '');
  //     //     cells['column3'] = PlutoCell(value: '');
  //     //     cells['column4'] = PlutoCell(value: treeAccount.account!.txtCode);
  //     //     cells['column5'] =
  //     //         PlutoCell(value: treeAccount.account!.txtEnglishname);
  //     //     cells['column6'] = PlutoCell(value: '');
  //     //     break;
  //     //   default:

  //     //     break;
  //     // }

  //     cells['ils'] =
  //         PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2));
  //     cells['usd'] =
  //         PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2));
  //     // Populate remaining cells
  //     for (int i = 1; i <= 13; i++) {
  //       cells['ils$i'] =
  //           PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2));
  //       cells['usd$i'] =
  //           PlutoCell(value: (random.nextDouble() * 100).toStringAsFixed(2));
  //     }
  //     stateManager.appendRows([PlutoRow(cells: cells)]);

  //     // rows.add(PlutoRow(cells: cells));
  //     if (treeAccount.children!.isNotEmpty) {
  //       populateRows(treeAccount.children!);
  //     }
  //   }
  //   // List<dynamic> children = treeAccounts;

  //   // for (int i = 0; i < treeAccounts.length; i++) {
  //   //   if (treeAccounts.isNotEmpty) {
  //   //     populateRows(treeAccounts[i].children!);
  //   //   }
  //   // }
  //   // for (var child in children) {
  //   //   populateRows(child);
  //   // }
  //   stateManager.setShowLoading(false);

  //   stateManager.notifyListeners();
  //   return rows;
  // }

  final double usdPer = 3.6;
  void _handleColumnTap(PlutoColumn column) {
    int currentIndex = polCol.indexOf(column);
    if (currentIndex < polCol.length - 1) {
      setState(() {
        polCol[currentIndex + 1].type = PlutoColumnType.text();
      });
    }
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

  fillColumn() {
    polCol.addAll([
      // PlutoColumn(
      //   frozen: PlutoColumnFrozen.start,
      //   width: 40,
      //   title: '',
      //   field: 'column2',
      //   readOnly: true,
      //   type: PlutoColumnType.text(),
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   renderer: (rendererContext) {
      //     return Tooltip(
      //       message: rendererContext.cell.value.toString(),
      //       child: Text(rendererContext.cell.value.toString()),
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   readOnly: true,
      //   frozen: PlutoColumnFrozen.start,
      //   width: 50,
      //   title: '',
      //   field: 'column3',
      //   type: PlutoColumnType.text(),
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   renderer: (rendererContext) {
      //     return Tooltip(
      //       message: rendererContext.cell.value.toString(),
      //       child: Text(rendererContext.cell.value.toString()),
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   width: 50,
      //   readOnly: true,
      //   title: '',
      //   frozen: PlutoColumnFrozen.start,
      //   field: 'column4',
      //   type: PlutoColumnType.text(),
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   renderer: (rendererContext) {
      //     return Tooltip(
      //       message: rendererContext.cell.value.toString(),
      //       child: Text(rendererContext.cell.value.toString()),
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   width: 50,
      //   title: '',
      //   readOnly: true,
      //   frozen: PlutoColumnFrozen.start,
      //   field: 'column5',
      //   type: PlutoColumnType.text(),
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   renderer: (rendererContext) {
      //     return Tooltip(
      //       message: rendererContext.cell.value.toString(),
      //       child: Text(rendererContext.cell.value.toString()),
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الحساب',
      //   frozen: PlutoColumnFrozen.start,
      //   readOnly: true,
      //   field: 'column6',
      //   type: PlutoColumnType.text(),
      //   renderer: (rendererContext) {
      //     return Tooltip(
      //       message: rendererContext.cell.value.toString(),
      //       child: Text(rendererContext.cell.value.toString()),
      //     );
      //   },
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      PlutoColumn(
        title: '(USD) الدولار',
        field: 'usd',
        readOnly: true,
        frozen: PlutoColumnFrozen.start,
        renderer: currencyRenderer,
        enableEditingMode: true,
        type: PlutoColumnType.currency(
          name: '',
          decimalDigits: 3,
          // negative: false,
        ),
        titleTextAlign: PlutoColumnTextAlign.center,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            format: '#',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              double sum = 0;
              // double sum = 0;
              for (int i = 0; i < polRows.length; i++) {
                if (polRows[i].cells['bolIsparent']!.value != 1) {
                  sum +=
                      double.parse(polRows[i].cells['usd']!.value.toString());
                }
              }
              return [
                TextSpan(
                    text: "${formatDouble(sum)} USD",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontSize: 18,
                      color: Colors.black,
                    )),
              ];
            },
          );
        },
      ),
      PlutoColumn(
        title: '(ILS) الشيكل',
        field: 'ils',
        frozen: PlutoColumnFrozen.start,

        type: PlutoColumnType.currency(
          name: '',
          decimalDigits: 3,
          // negative: false,
        ),
        // width: width * 0.3,
        readOnly: true,
        renderer: currencyRenderer,
        // enableEditingMode: true,
        // type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            formatAsCurrency: true,
            type: PlutoAggregateColumnType.sum,
            format: '#',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              double sum = 0;
              for (int i = 0; i < polRows.length; i++) {
                if (polRows[i].cells['bolIsparent']!.value != 1) {
                  sum +=
                      double.parse(polRows[i].cells['ils']!.value.toString());
                }
              }
              return [
                TextSpan(
                    text: "${formatDouble(sum)} ILS",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontSize: 18,
                      color: Colors.black,
                    )),
              ];
            },
          );
        },
      ),

      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils1',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils1']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   field: 'usd1',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd1']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   enableEditingMode: true,
      //   field: 'ils2',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils2']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   enableEditingMode: true,
      //   field: 'usd2',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd2']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils3',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils3']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   enableEditingMode: true,
      //   field: 'usd3',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd3']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   enableEditingMode: true,
      //   field: 'ils4',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils4']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   enableEditingMode: true,
      //   title: 'الدولار',
      //   field: 'usd4',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd4']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   enableEditingMode: true,
      //   field: 'ils5',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils5']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   enableEditingMode: true,
      //   field: 'usd5',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd5']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   enableEditingMode: true,
      //   title: 'الشيكل',
      //   field: 'ils6',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils6']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   field: 'usd6',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd6']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils7',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   enableEditingMode: true,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils7']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   field: 'usd7',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd7']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils8',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils8']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   field: 'usd8',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd8']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils9',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['ils9']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   enableEditingMode: true,
      //   field: 'usd9',
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum += double.parse(polRows[i].cells['usd9']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils10',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   enableEditingMode: true,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum +=
      //               double.parse(polRows[i].cells['ils10']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   field: 'usd10',
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum +=
      //               double.parse(polRows[i].cells['usd10']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   enableEditingMode: true,
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils11',
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum +=
      //               double.parse(polRows[i].cells['ils11']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   enableEditingMode: true,
      //   field: 'usd11',
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum +=
      //               double.parse(polRows[i].cells['usd11']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils12',
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum +=
      //               double.parse(polRows[i].cells['ils12']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   enableEditingMode: true,
      //   type: PlutoColumnType.text(),
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   field: 'usd12',
      //   enableEditingMode: true,
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum +=
      //               double.parse(polRows[i].cells['usd12']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الشيكل',
      //   field: 'ils13',
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum +=
      //               double.parse(polRows[i].cells['ils13']!.value.toString());
      //         }
      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} ILS",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   enableEditingMode: true,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      // ),
      // PlutoColumn(
      //   title: 'الدولار',
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.sum,
      //       format: '#',
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         double sum = 0;
      //         for (int i = 0; i < polRows.length; i++) {
      //           sum +=
      //               double.parse(polRows[i].cells['usd13']!.value.toString());
      //         }

      //         return [
      //           TextSpan(
      //               text: "${formatDouble(sum)} USD",
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 // fontSize: 18,
      //                 color: Colors.black,
      //               )),
      //         ];
      //       },
      //     );
      //   },
      //   field: 'usd13',
      //   type: PlutoColumnType.currency(
      //     name: '',
      //     decimalDigits: 3,
      //     // negative: false,
      //   ),
      //   renderer: currencyRenderer,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   enableEditingMode: true,
      // ),
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
        title: 'الاجمالي',
        children: [
          PlutoColumnGroup(
            fields: ['ils', 'usd'],
            title: '',
          ),
        ],
      ),
    ]);
  }
}
