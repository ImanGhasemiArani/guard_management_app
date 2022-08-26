import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guard_management_app/services/pdf_service.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../lang/strs.dart';
import '../../model/user.dart';
import '../../services/server_service.dart';
import '../../utils/data_utils.dart';
import '../calendar/src/persian_date.dart';
import '../future_builder/custom_future_builder.dart';

final GlobalKey<SfDataGridState> dataGridKey = GlobalKey<SfDataGridState>();

class ShiftScheduleTableView extends StatelessWidget {
  const ShiftScheduleTableView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: Future.sync(
        () async {
          final f = Jalali.now().formatter;
          return DataUtils.sortByTeam(await ServerService.getAllUserSchedule(
            isFilterDate: true,
            afterDate: "${f.y}-${f.m}-${f.d}",
          ));
        },
      ),
      builder: (context, data) {
        AutoSizeGroup group = AutoSizeGroup();
        return Column(
          children: [
            CupertinoButton(
              child: Text("Click"),
              onPressed: () {
                PdfService.createShiftSchedulePdf(dataGridKey);
              },
            ),
            Expanded(
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                      brightness: Get.theme.brightness,
                      headerColor: Get.theme.colorScheme.background,
                      gridLineColor:
                          Get.theme.colorScheme.onBackground.withOpacity(0.4),
                      frozenPaneLineColor:
                          Get.theme.colorScheme.onBackground.withOpacity(0.4),
                      gridLineStrokeWidth: 1,
                      frozenPaneElevation: 0,
                    ),
                    child: SfDataGrid(
                      key: dataGridKey,
                      horizontalScrollPhysics: const BouncingScrollPhysics(),
                      verticalScrollPhysics: const BouncingScrollPhysics(),
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      columnWidthMode: ColumnWidthMode.auto,
                      source:
                          ShiftDataSource(data as List<Map<String, dynamic>>),
                      frozenColumnsCount: 1,
                      columns: _buildColumns(group),
                      stackedHeaderRows: _buildStackHeaders(group),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<StackedHeaderRow> _buildStackHeaders(AutoSizeGroup group) {
    var cells = [
      StackedHeaderCell(
        columnNames: ['name', 'rank', 'post'],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 1,
                color: Get.theme.colorScheme.onBackground.withOpacity(0.4),
              ),
            ),
          ),
          child: AutoSizeText(
            Strs.companyNameStr.tr,
            maxLines: 1,
            //   minFontSize: 5,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Get.theme.textTheme.bodyText1?.fontFamily,
              fontStyle: Get.theme.textTheme.bodyText1?.fontStyle,
              fontSize: Get.theme.textTheme.bodyText1?.fontSize,
              fontWeight: Get.theme.textTheme.bodyText1?.fontWeight,
              letterSpacing: Get.theme.textTheme.bodyText1?.letterSpacing,
            ),
          ),
        ),
      ),
      StackedHeaderCell(
        columnNames: ['team'],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: AutoSizeText(
            Strs.weekdayStr.tr,
            group: group,
            maxLines: 2,
            //   minFontSize: 5,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Get.theme.textTheme.bodyText1?.fontFamily,
              fontStyle: Get.theme.textTheme.bodyText1?.fontStyle,
              fontSize: Get.theme.textTheme.bodyText1?.fontSize,
              fontWeight: Get.theme.textTheme.bodyText1?.fontWeight,
              letterSpacing: Get.theme.textTheme.bodyText1?.letterSpacing,
            ),
          ),
        ),
      ),
    ];
    var date = Jalali.now();
    for (var dayNum in Iterable<int>.generate(date.monthLength).toList()) {
      var newDate = Jalali(date.year, date.month, dayNum + 1);
      final dayShortName = dayShort[(newDate.weekDay - 1 - 2) % 7];
      cells.add(
        StackedHeaderCell(
          columnNames: ['${dayNum + 1}'],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: AutoSizeText(
              dayShortName,
              group: group,
              maxLines: 1,
              //   minFontSize: 5,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Get.theme.textTheme.bodyText1?.fontFamily,
                fontStyle: Get.theme.textTheme.bodyText1?.fontStyle,
                fontSize: Get.theme.textTheme.bodyText1?.fontSize,
                fontWeight: Get.theme.textTheme.bodyText1?.fontWeight,
                letterSpacing: Get.theme.textTheme.bodyText1?.letterSpacing,
              ),
            ),
          ),
        ),
      );
    }
    return [StackedHeaderRow(cells: cells)];
  }

  List<GridColumn> _buildColumns(AutoSizeGroup group) {
    final columns = [
      GridColumn(
        columnName: 'name',
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: AutoSizeText(
            Strs.fullNameStr.tr,
            group: group,
            maxLines: 1,
            //   minFontSize: 5,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Get.theme.textTheme.bodyText1?.fontFamily,
              fontStyle: Get.theme.textTheme.bodyText1?.fontStyle,
              fontSize: Get.theme.textTheme.bodyText1?.fontSize,
              fontWeight: Get.theme.textTheme.bodyText1?.fontWeight,
              letterSpacing: Get.theme.textTheme.bodyText1?.letterSpacing,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'rank',
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: AutoSizeText(
            Strs.rankingStr.tr,
            group: group,
            maxLines: 1,
            //   minFontSize: 5,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Get.theme.textTheme.bodyText1?.fontFamily,
              fontStyle: Get.theme.textTheme.bodyText1?.fontStyle,
              fontSize: Get.theme.textTheme.bodyText1?.fontSize,
              fontWeight: Get.theme.textTheme.bodyText1?.fontWeight,
              letterSpacing: Get.theme.textTheme.bodyText1?.letterSpacing,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'post',
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: AutoSizeText(
            Strs.postStr.tr,
            group: group,
            maxLines: 1,
            //   minFontSize: 5,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Get.theme.textTheme.bodyText1?.fontFamily,
              fontStyle: Get.theme.textTheme.bodyText1?.fontStyle,
              fontSize: Get.theme.textTheme.bodyText1?.fontSize,
              fontWeight: Get.theme.textTheme.bodyText1?.fontWeight,
              letterSpacing: Get.theme.textTheme.bodyText1?.letterSpacing,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'team',
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: AutoSizeText(
            Strs.dateStr.tr,
            group: group,
            maxLines: 1,
            //   minFontSize: 5,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Get.theme.textTheme.bodyText1?.fontFamily,
              fontStyle: Get.theme.textTheme.bodyText1?.fontStyle,
              fontSize: Get.theme.textTheme.bodyText1?.fontSize,
              fontWeight: Get.theme.textTheme.bodyText1?.fontWeight,
              letterSpacing: Get.theme.textTheme.bodyText1?.letterSpacing,
            ),
          ),
        ),
      ),
    ];
    var date = Jalali.now();
    for (var dayNum in Iterable<int>.generate(date.monthLength).toList()) {
      var newDate = Jalali(date.year, date.month, dayNum + 1);
      columns.add(
        GridColumn(
          columnName: '${dayNum + 1}',
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: AutoSizeText(
              '${dayNum + 1}',
              group: group,
              maxLines: 1,
              //   minFontSize: 5,
              maxFontSize: 12,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Get.theme.textTheme.bodyText1?.fontFamily,
                fontStyle: Get.theme.textTheme.bodyText1?.fontStyle,
                fontSize: Get.theme.textTheme.bodyText1?.fontSize,
                fontWeight: Get.theme.textTheme.bodyText1?.fontWeight,
                letterSpacing: Get.theme.textTheme.bodyText1?.letterSpacing,
              ),
            ),
          ),
        ),
      );
    }
    return columns;
  }
}

class ShiftDataSource extends DataGridSource {
  ShiftDataSource(List<Map<String, dynamic>> shifts) {
    _shifts = shifts.map<DataGridRow>((e) {
      var date = Jalali.now();
      var cells = [
        DataGridCell<String>(columnName: 'name', value: e['name']),
        DataGridCell<String>(columnName: 'rank', value: e['rank'] ?? ""),
        DataGridCell<String>(columnName: 'post', value: e['post']),
        DataGridCell<String>(
            columnName: 'team', value: "${Strs.teamStr} ${e['teamName']}"),
      ];
      for (var dayNum in Iterable<int>.generate(date.monthLength).toList()) {
        cells.add(
          DataGridCell<String>(columnName: '${dayNum + 1}', value: " "),
        );
      }
      (e['shifts'] as Map<String, dynamic>).forEach(
        (key, value) {
          final jalaliStr =
              key.split('-').map((str) => int.parse(str)).toList();
          cells[jalaliStr[2] + 3] = DataGridCell<String>(
              columnName: '${jalaliStr[2]}',
              value: ShiftType.valueOf(value['des']).value[0]);
        },
      );
      return DataGridRow(cells: cells);
    }).toList();
  }

  List<DataGridRow> _shifts = [];

  @override
  List<DataGridRow> get rows => _shifts;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: Get.theme.colorScheme.surface,
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            color: dataGridCell.columnName == 'name'
                ? Get.theme.colorScheme.background
                : null,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Get.theme.textTheme.bodyText2?.fontFamily,
                fontStyle: Get.theme.textTheme.bodyText2?.fontStyle,
                fontSize: Get.theme.textTheme.bodyText2?.fontSize,
                fontWeight: Get.theme.textTheme.bodyText2?.fontWeight,
                letterSpacing: Get.theme.textTheme.bodyText2?.letterSpacing,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
