import 'package:flutter/material.dart';
import 'package:hadadi/pages/Supplier/store_dashboard_page/widgets/sales_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesTrendChart extends StatelessWidget {
  final List<SalesData> data;
  final bool isHebrew;

  const SalesTrendChart({
    required this.data,
    required this.isHebrew,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.all(12.0),
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelStyle: TextStyle(color: Color(0xFF767676), fontSize: 12),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(width: 0),
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: const NumericAxis(
            labelStyle: TextStyle(color: Color(0xFF767676), fontSize: 12),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(width: 0),
            majorGridLines: MajorGridLines(width: 1, color: Color(0xFFC1C3EE)),
          ),
          plotAreaBorderWidth: 0,
          series: <CartesianSeries>[
            AreaSeries<SalesData, String>(
              dataSource: data,
              xValueMapper: (SalesData sales, _) => sales.formattedDate,
              yValueMapper: (SalesData sales, _) => sales.sales,
              color: const Color.fromRGBO(193, 195, 238, 0.74),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  final SalesData sales = data as SalesData;
                  return sales.sales != 0.0
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            '₪${sales.sales.toInt()}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF4C52CC),
                              fontFamily: 'Rubik',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(8, 8),
                                  blurRadius: 16,
                                  color: Color.fromRGBO(215, 215, 215, 0.80),
                                ),
                                Shadow(
                                  offset: Offset(-8, -8),
                                  blurRadius: 16,
                                  color: Color.fromRGBO(255, 255, 255, 0.80),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
              markerSettings: const MarkerSettings(
                isVisible: true,
                shape: DataMarkerType.circle,
                color: Color(0xFF000089),
                borderWidth: 0,
              ),
              borderColor: const Color(0xFF000089),
              borderWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
