import 'package:brenco_keys/models/key.dart' as LicenseKey;
import 'package:brenco_keys/providers/api.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flushbar/flushbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<LicenseKey.Key>> futureKeys;
  List<LicenseKey.Key> _selectedKeys;

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureKeys = api.fetchKeys();
    _selectedKeys = [];
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                icon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'Create',
                ),
                onPressed: () {
                  _addKey(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              Visibility(
                visible: _selectedKeys.length == 1,
                child: RaisedButton.icon(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Remove',
                  ),
                  onPressed: () {
                    api.removeKey(_selectedKeys[0].id).then((res) {
                      setState(() {
                        _selectedKeys = [];
                      });
                    }).catchError((error) {
                      print(error);
                      Flushbar(
                        title: "Hey!",
                        message: error,
                        duration: Duration(seconds: 4),
                      )..show(context);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SingleChildScrollView(
                    child: FutureBuilder<List<LicenseKey.Key>>(
                  future: futureKeys,
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

  void _addKey(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: Wrap(
                children: <Widget>[
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).size.width) * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: TextField(
                            controller: _nameController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Name",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.add_circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                                _nameController.clear();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () {
                                if (_nameController.text.isNotEmpty) {
                                  api.createKey(_nameController.text).then((_) {
                                    Navigator.pop(context);
                                    _nameController.clear();
                                  }).catchError((error) {
                                    print(error);
                                    Flushbar(
                                      title: "Hey!",
                                      message: error,
                                      duration: Duration(seconds: 4),
                                    )..show(context);
                                  });
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
