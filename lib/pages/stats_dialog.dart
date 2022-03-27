import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:share_plus/share_plus.dart';
import 'package:wordle/models/result_object.dart';
import 'package:wordle/models/result_status.dart';
import 'package:collection/collection.dart';

Future<void> showStatsDialog(context, String title, Function dataFn,
    {String? share}) async {
  List<ResultObject> data = dataFn().toList();
  int totalPlayed =
      data.where((element) => element.status != ResultStatus.INCOMPLETE).length;
  int totalWin =
      data.where((element) => element.status == ResultStatus.SUCCESS).length;
  int maxStreak = 0;
  int currentStreak = 0;
  List<int> guessDistribution = List.filled(6, 0);

  for (ResultObject obj in data) {
    if (obj.status == ResultStatus.SUCCESS) {
      currentStreak++;
      int guessIndex = obj.guessedWords.indexOf('');
      if (guessIndex == -1) {
        guessIndex = obj.guessedWords.length;
      }
      guessDistribution[guessIndex - 1] = guessDistribution[guessIndex - 1] + 1;
    } else if (obj.status == ResultStatus.INCOMPLETE) {
      continue;
    } else {
      if (maxStreak < currentStreak) {
        maxStreak = currentStreak;
      }
      currentStreak = 0;
    }
  }
  if (maxStreak < currentStreak) {
    maxStreak = currentStreak;
  }
  List<Map<String, int>> mapData = [];
  guessDistribution.forEachIndexed((index, val) {
    Map<String, int> map = {};
    map['key'] = index + 1;
    map['value'] = val;
    mapData.add(map);
  });
  print(mapData);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        title: Center(child: Text(title)),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: ListBody(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(totalPlayed.toString()),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "Played",
                                            textAlign: TextAlign.center,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(totalPlayed > 0
                                          ? (totalWin * 100 ~/ totalPlayed)
                                              .toString()
                                          : '0'),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "Win %",
                                            textAlign: TextAlign.center,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(maxStreak.toString()),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "Max Streak",
                                            textAlign: TextAlign.center,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(currentStreak.toString()),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "Current Streak",
                                        textAlign: TextAlign.center,
                                      ))
                                ],
                              ),
                            ),
                          )
                        ])),
                Text(
                  "Guess distribution",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    width: 200,
                    height: 200,
                    child: charts.BarChart(
                      [
                        charts.Series<Map<String, int>, String>(
                            id: 'Guess Distribution',
                            domainFn: (Map<String, int> val, _) =>
                                val['key'].toString(),
                            measureFn: (Map<String, int> val, _) =>
                                val['value'],
                            data: mapData,
                            labelAccessorFn: (Map<String, int> val, _) =>
                                val['value'].toString())
                      ],
                      animate: true,
                      secondaryMeasureAxis: charts.NumericAxisSpec(
                          renderSpec: charts.GridlineRendererSpec(
                              labelStyle: charts.TextStyleSpec(
                                  fontSize: 10,
                                  color: charts.ColorUtil.fromDartColor(
                                      Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color ??
                                          Colors.white)))),
                      domainAxis: charts.OrdinalAxisSpec(
                          renderSpec: charts.SmallTickRendererSpec(
                              labelStyle: charts.TextStyleSpec(
                                  fontSize: 10,
                                  color: charts.ColorUtil.fromDartColor(
                                      Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color ??
                                          Colors.white)))),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                          renderSpec: charts.GridlineRendererSpec(
                              labelStyle: charts.TextStyleSpec(
                                  fontSize: 10,
                                  color: charts.ColorUtil.fromDartColor(
                                      Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color ??
                                          Colors.white)))),
                      barRendererDecorator: charts.BarLabelDecorator<String>(),
                    )),
                Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (data.isNotEmpty &&
                              data[data.length - 1].status !=
                                  ResultStatus.INCOMPLETE) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/", (r) => false);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.close),
                        label: const Text("close"),
                      ),
                      if (share != null && share.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () async {
                            await Share.share(
                              share,
                              subject: 'Wordles',
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text("share"),
                        )
                    ]))
              ],
            ),
          ),
        ),
      );
    },
  );
}
