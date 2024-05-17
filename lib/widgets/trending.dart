import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrendingChart extends StatelessWidget {
  final int score;
  final bool isUpvoted;
  final bool isDownvoted;
  final List<int> upvotes;
  final List<int> downvotes;
  final VoidCallback onUpvotePressed;
  final VoidCallback onDownvotePressed;

  const TrendingChart({
    Key? key,
    required this.score,
    required this.isUpvoted,
    required this.isDownvoted,
    required this.upvotes,
    required this.downvotes,
    required this.onUpvotePressed,
    required this.onDownvotePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Contador:',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Text(
            '$score',
            key: ValueKey<int>(score),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        if (score >= 5)
          Text(
            '¡Post recomendado!',
            style: TextStyle(color: Colors.green, fontSize: 18),
          ),
        if (score <= -5)
          Text(
            'Post no recomendado',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        SizedBox(height: 20),
        Container(
          width: 200,
          height: 150,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 5,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String day = (group.x + 1).toString();
                    return BarTooltipItem(
                      'Día $day\n',
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: rod.y.toString(),
                          style: TextStyle(
                            color: rod.colors[0],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  margin: 16,
                  getTitles: (double value) {
                    return (value + 1).toInt().toString();
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: List.generate(5, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      y: upvotes[index].toDouble(),
                      colors: [Colors.green],
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      y: downvotes[index].toDouble(),
                      colors: [Colors.red],
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                color: isUpvoted ? Colors.green : Colors.grey,
                size: 30,
              ),
              onPressed: onUpvotePressed,
            ),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(
                Icons.thumb_down,
                color: isDownvoted ? Colors.red : Colors.grey,
                size: 30,
              ),
              onPressed: onDownvotePressed,
            ),
          ],
        ),
      ],
    );
  }
}
