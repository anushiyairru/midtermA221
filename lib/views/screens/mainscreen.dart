import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypasarv2/config.dart';

import 'package:ndialog/ndialog.dart';
import '../../models/Homestay.dart';
import '../../models/user.dart';
import '../shared/mainmenu.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Homestay> homestayList = <Homestay>[];
  String titlecenter = "Loading...";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  //for pagination
  var color;
  var numofpage, curpage = 1;
  int numberofresult = 0;
//for pagination
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadhomestays("all", 1);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Buyers"), actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _loadSearchDialog();
              },
            ),
          ]),
          body: homestayList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "homestays/services ($numberofresult found)",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: rowcount,
                        children: List.generate(homestayList.length, (index) {
                          return Card(
                            elevation: 8,
                            child: InkWell(
                              onTap: _showDetails,
                              child: Column(children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    width: resWidth / 2,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${Config.SERVER}/assets/homestayimages/${homestayList[index].homestayId}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            truncateString(
                                                homestayList[index]
                                                    .homestayName
                                                    .toString(),
                                                15),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "RM ${double.parse(homestayList[index].homestayPrice.toString()).toStringAsFixed(2)}"),
                                          Text(df.format(DateTime.parse(
                                              homestayList[index]
                                                  .homestayDate
                                                  .toString()))),
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                          );
                        }),
                      ),
                    ),
                    //pagination widget
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          //build the list for textbutton with scroll
                          if ((curpage - 1) == index) {
                            //set current page number active
                            color = Colors.red;
                          } else {
                            color = Colors.black;
                          }
                          return SizedBox(
                            width: 50,
                            child: TextButton(
                                onPressed: () =>
                                    {_loadhomestays(search, index + 1)},
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: color, fontSize: 18),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          drawer: MainMenuWidget(user: widget.user),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void _loadhomestays(String search, int pageno) {
    curpage = pageno; //init current page
    numofpage ?? 1; //get total num of pages if not by default set to only 1
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: null,
    );
    progressDialog.show();

    http
        .get(
      Uri.parse(
          "${Config.SERVER}/php/loadallhomestays.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      print(response.body);
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array

          if (extractdata['homestays'] != null) {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata[
                'numberofresult']); //get total number of result returned
            //check if  array object is not null
            homestayList = <Homestay>[]; //complete the array object definition
            extractdata['homestays'].forEach((v) {
              //traverse homestays array list and add to the list object array homestayList
              homestayList.add(Homestay.fromJson(
                  v)); //add each homestay array to the list object array homestayList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No homestay Available"; //if no data returned show title center
            homestayList.clear();
          }
        }
        progressDialog.dismiss();
      } else {
        titlecenter = "No homestay Available"; //status code other than 200
        homestayList.clear(); //clear homestayList array
      }
      progressDialog.dismiss();
      setState(() {}); //refresh UI
    });
    progressDialog.dismiss();
  }

  void _showDetails() {}

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadhomestays(search, 1);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }
}
