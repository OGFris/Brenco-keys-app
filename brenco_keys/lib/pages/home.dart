import 'package:brenco_keys/models/key.dart' as LicenseKey;
import 'package:brenco_keys/providers/api.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<LicenseKey.Key>> futureKey;

  @override
  void initState() {
    super.initState();
    futureKey = api.fetchKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Brenco Keys"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SingleChildScrollView(
                    child: FutureBuilder<List<LicenseKey.Key>>(
                  future: futureKey,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<LicenseKey.Key>> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container(
                            width: (MediaQuery.of(context).size.width),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List<Widget>.filled(
                                5,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.black12,
                                    highlightColor: Colors.black26,
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width),
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                growable: false,
                              ),
                            ),
                          );
                        default:
                          return DataTable(
                            columns: [
                              DataColumn(
                                label: Text("Name"),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text("Key"),
                                numeric: false,
                              ),
                            ],
                            rows: snapshot.data
                                .map(
                                  (LicenseKey.Key key) => DataRow(
                                    /*selected:
                                            _selectedProducts.contains(product),
                                        onSelectChanged: (selected) {
                                          _onSelectedRow(selected, product);
                                        },*/
                                    cells: [
                                      DataCell(
                                        Text(
                                          key.name,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          key.key,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          );
                      }
                    }
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
