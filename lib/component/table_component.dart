import 'package:flutter/material.dart';
import 'package:new_table/constants/colors.dart';
import 'package:pluto_grid/pluto_grid.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class TableComponent extends StatefulWidget {
  final List<PlutoColumn> plCols;
  final List<PlutoRow> polRows;
   final List<PlutoColumnGroup>? columnGroups;
  final Widget Function(PlutoGridStateManager stateManager)? footerBuilder;
  final Function(PlutoGridOnSelectedEvent event)? onSelected;
  final Function(PlutoGridOnChangedEvent event)? onChange;

  final Function(PlutoGridOnLoadedEvent event)? onLoaded;
  final Function(PlutoGridOnRowDoubleTapEvent event)? doubleTab;
  final Function(PlutoGridOnRowSecondaryTapEvent event)? rightClickTap;
  final Function(PlutoGridStateManager event)? headerBuilder;
  final Function(PlutoGridOnRowCheckedEvent event)? handleOnRowChecked;
  bool? isWhiteText = false;
  PlutoGridMode? mode;
  Color? borderColor;
  double? rowsHeight;
  double? columnHeight;
  PlutoGridEnterKeyAction? moveAfterEditng;
  Color Function(PlutoRowColorContext)? rowColor;
  // PlutoGridStateManager stateManger;
  Key? key;
  TableComponent(
      {this.key,
      required this.plCols,
      required this.polRows,
      this.columnGroups,
      this.onSelected,
      this.columnHeight,
      this.footerBuilder,
      this.isWhiteText,
      this.doubleTab,
      this.rightClickTap,
      this.headerBuilder,
      this.onLoaded,
      this.mode,
      this.onChange,
      this.handleOnRowChecked,
      this.borderColor,
      this.rowsHeight,
      this.moveAfterEditng,
      this.rowColor
      // required this.stateManger
      });
  @override
  State<TableComponent> createState() => _TableComponentState();
}

class _TableComponentState extends State<TableComponent> {
  double width = 0;
  double height = 0;
  double scrollThickness = 10;
  double scrollRadius = 10;
  late final PlutoGridStateManager stateManager;
  // late AppLocalizations locale;

  @override
  void didChangeDependencies() {
    // locale = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    List<PlutoColumn> polCols = widget.plCols;
    List<PlutoRow> polRows = widget.polRows;

    return PlutoGrid(
      
      columnGroups: widget.columnGroups??[],
      configuration: PlutoGridConfiguration(
        localeText: PlutoGridLocaleText(
            // freezeColumnToStart: locale.freezeColumnToStart,
            // freezeColumnToEnd: locale.freezeColumnToEnd,
            // autoFitColumn: locale.autoFit,
            // hideColumn: locale.hideColumn,
            // setColumns: locale.setColumns,
            // setFilter: locale.setFilter,
            // resetFilter: locale.resetFilter,
            // filterColumn: locale.tableColumn,
            // filterType: locale.type,
            // filterValue: locale.value,
            // filterContains: locale.contains,
            // filterEquals: locale.equals,
            // filterEndsWith: locale.endsWith,
            // filterLessThan: locale.lessThan,
            // filterGreaterThan: locale.greaterThan,
            // filterGreaterThanOrEqualTo: locale.greaterThanOrEqual,
            // filterStartsWith: locale.startsWith,
            // filterLessThanOrEqualTo: locale.lessThanOrEqual
            ),
        enableMoveHorizontalInEditing: true,
        enterKeyAction: widget.moveAfterEditng ??
            PlutoGridEnterKeyAction.editingAndMoveDown,
        // tabKeyAction: PlutoGridTabKeyAction.normal,
        columnSize: const PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.none),
//localeText: PlutoGridLocaleText(filterContains: locale.contains),
        scrollbar: PlutoGridScrollbarConfig(
          onlyDraggingThumb: false,
          scrollbarThicknessWhileDragging: 20,
          draggableScrollbar: true,
          isAlwaysShown: true,
          scrollBarColor: primary2,
          scrollbarThickness: scrollThickness,
          scrollbarRadius: Radius.circular(scrollRadius),
        ),
        style: PlutoGridStyleConfig(
          evenRowColor: Colors.grey[100],
          oddRowColor: Colors.white,
          activatedBorderColor:
              const Color.fromARGB(255, 37, 171, 233).withOpacity(0.5),
          activatedColor:
              const Color.fromARGB(255, 37, 171, 233).withOpacity(0.5),
          enableCellBorderVertical: false,
          enableGridBorderShadow: true,
          gridBorderColor: widget.borderColor == null
              ? const Color(0xFFA1A5AE)
              : widget.borderColor!,
          menuBackgroundColor: Colors.white,
          columnHeight: widget.columnHeight ?? 30,
          columnFilterHeight: 30,
          columnTextStyle: TextStyle(
              fontSize: 14,
              color: widget.isWhiteText ?? false ? Colors.white : Colors.black,
              letterSpacing: 1),
          rowHeight: widget.rowsHeight ?? 25,
          cellTextStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
      createFooter: (stateManager) {
        if (widget.footerBuilder != null) {
          return widget.footerBuilder!(stateManager);
        }
        return const SizedBox();
      },
      columns: polCols,
      rows: polRows,
      mode: widget.mode != null ? widget.mode! : PlutoGridMode.selectWithOneTap,
      onRowDoubleTap: widget.doubleTab != null
          ? (event) {
              widget.doubleTab!(event);
            }
          : null,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        if (widget.onLoaded != null) {
          widget.onLoaded!(event);
        }
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        if (widget.onChange != null) {
          widget.onChange!(event);
        }
      },
      onSelected: (event) {
        if (widget.onSelected != null) {
          widget.onSelected!(event);
        }
      },
      rowColorCallback: widget.rowColor,
      // rowColorCallback: widget.rowColor,
      noRowsWidget: const Center(
        child: Text("No data available."),
      ),
      onRowSecondaryTap: (event) {
        if (widget.rightClickTap != null) {
          widget.rightClickTap!(event);
        }
      },
      createHeader: (stateManager) {
        if (widget.headerBuilder != null) {
          return widget.headerBuilder!(stateManager);
        }
        return const SizedBox();
      },
      onRowChecked: widget.handleOnRowChecked,
    );
  }
}
