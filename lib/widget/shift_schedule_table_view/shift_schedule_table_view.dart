import 'package:auto_size_text/auto_size_text.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../lang/strs.dart';
import '../../model/user.dart';
import '../../services/pdf_service.dart';
import '../calendar/shamsi_table_calendar.dart';
import '../future_builder/custom_future_builder.dart';

final GlobalKey<SfDataGridState> dataGridKey = GlobalKey<SfDataGridState>();

class ShiftScheduleTableView extends StatelessWidget {
  const ShiftScheduleTableView({
    Key? key,
    this.future,
  }) : super(key: key);

  final Future<Object?>? future;

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: future,
      builder: (context, data) {
        AutoSizeGroup group = AutoSizeGroup();
        return Column(
          children: [
            _buildExportToPdfBtn(data),
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

  Widget _buildExportToPdfBtn(dynamic data) {
    final isShowButtonIndicator = false.obs;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: ShapeDecoration(
          color: Get.theme.colorScheme.secondary.withOpacity(0.05),
          shape: SmoothRectangleBorder(
            side: BorderSide(
                color: Get.theme.colorScheme.secondary.withOpacity(0.5)),
            borderRadius: SmoothBorderRadius(
              cornerRadius: 15,
              cornerSmoothing: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                Strs.exportToPdfDescriptionStr.tr,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  height: 52,
                  child: CupertinoButton(
                    onPressed: () =>
                        _onExportToPdfBtnPressed(isShowButtonIndicator, data),
                    child: Obx(
                      () => !isShowButtonIndicator.value
                          ? Text(
                              Strs.exportToPdfStr.tr,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily:
                                    Get.theme.textTheme.button!.fontFamily,
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: CircularProgressIndicator(
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // final isShowButtonIndicator = false.obs;
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //   child: ClipSmoothRect(
    //     radius: SmoothBorderRadius(
    //       cornerRadius: 15,
    //       cornerSmoothing: 1,
    //     ),
    //     child: SizedBox(
    //       width: double.infinity,
    //       height: 52,
    //       child: CupertinoButton.filled(
    //         onPressed: () => _onExportToPdfBtnPressed(isShowButtonIndicator),
    //         child: Obx(
    //           () => !isShowButtonIndicator.value
    //               ? Text(
    //                   Strs.exportToPdfStr.tr,
    //                   textDirection: TextDirection.rtl,
    //                   style: TextStyle(
    //                     fontFamily: Get.theme.textTheme.button!.fontFamily,
    //                   ),
    //                 )
    //               : FittedBox(
    //                   fit: BoxFit.scaleDown,
    //                   child: CircularProgressIndicator(
    //                     color: Get.theme.colorScheme.onPrimary,
    //                   ),
    //                 ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  _onExportToPdfBtnPressed(RxBool isShowButtonIndicator, dynamic data) {
    if (isShowButtonIndicator.value) return;
    isShowButtonIndicator.value = true;

    PdfService.createShiftSchedulePdf(dataGridKey)
        .then((value) => isShowButtonIndicator.value = false);
  }

  List<StackedHeaderRow> _buildStackHeaders(AutoSizeGroup group) {
    var cells = [
      StackedHeaderCell(
        columnNames: [Strs.fullNameStr.tr, Strs.rankingStr.tr, Strs.postStr.tr],
        text: Strs.companyNameStr.tr,
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
        columnNames: [Strs.dateStr.tr],
        text: Strs.weekdayStr.tr,
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
      final dayShortName = dayExp[(newDate.weekDay - 1 - 2) % 7];
      cells.add(
        StackedHeaderCell(
          columnNames: ['${dayNum + 1}'],
          text: dayShortName,
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
        columnName: Strs.fullNameStr.tr,
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
        columnName: Strs.rankingStr.tr,
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
        columnName: Strs.postStr.tr,
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
        columnName: Strs.dateStr.tr,
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
        DataGridCell<String>(columnName: Strs.fullNameStr.tr, value: e['name']),
        DataGridCell<String>(
            columnName: Strs.rankingStr.tr, value: e['rank'] ?? ""),
        DataGridCell<String>(columnName: Strs.postStr.tr, value: e['post']),
        DataGridCell<String>(
            columnName: Strs.dateStr.tr,
            value: "${Strs.teamStr} ${e['teamName']}"),
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
              value: (value['des'] as String)
                  .characters
                  .map((e) => ShiftType.valueOf(e).value[0])
                  .toList()
                  .join(' '));
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
            color: dataGridCell.columnName == Strs.fullNameStr.tr
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
