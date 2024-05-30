import 'package:chatapp/page/chatpage.dart';
import 'package:chatapp/service/database.dart';
import 'package:chatapp/service/shared_prefirences.data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  //  take the data on sharedPrefremce
  getthesharedpre() async {
    myName = await SharedPreferenceHelper().getUserDisplay();
    myUserName = await SharedPreferenceHelper().getUserNeme();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  // this function is call the getthe sharedpre method
  ontheload() async {
    await getthesharedpre();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ontheload();
  }

  // this function is used to get the uniqe chat id on firebase
  getChatRoomIdbyusername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.toString().length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    print("value of ${capitalizedValue}");
    if (queryResultSet.length == 0 && value.toString().length == 1) {
      DataBaseMethod().Search(value).then(
        (QuerySnapshot docs) {
          for (int i = 0; i < docs.docs.length; ++i) {
            queryResultSet.add(docs.docs[i].data());
          }
        },
      );
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element["Username"].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: SingleChildScrollView(
        child: Container(
          // margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 50, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  search
                      ? Expanded(
                          child: TextField(
                            onChanged: (value) {
                              initiateSearch(value.toUpperCase());
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search User",
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Text(
                          "ChatUp",
                          style: TextStyle(
                              color: Color(0xFFc199cd),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                  GestureDetector(
                    onTap: () {
                      search = true;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 35, 26, 41),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: search
                            ? GestureDetector(
                                onTap: () {
                                  search = false;
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xFFc199cd),
                                ),
                              )
                            : Icon(
                                Icons.search,
                                color: Color(0xFFc199cd),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              height: search
                  ? MediaQuery.of(context).size.height / 1.19
                  : MediaQuery.of(context).size.height / 1.15,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  search
                      ? ListView(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          primary: true,
                          shrinkWrap: true,
                          children: tempSearchStore.map((element) {
                            return buildResultCard(element);
                          }).toList())
                      : Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatsPage(),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      "assets/images/man1.jpg",
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Roshan Barkane",
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        " Hello,What are you doing? ",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    "04:50 PM",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    "assets/images/human.jpg",
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Khushi Patil",
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      " Hey, Are you taking party? ",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  "04:50 PM",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        search = false;
        setState(() {});

        var chatRoomId = getChatRoomIdbyusername(myUserName!, data["Username"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, data['Username']],
        };

        await DataBaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      data["Photo"],
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      data["Username"],
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
