import 'dart:math';

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
  Stream? chatRoomStream;

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
    chatRoomStream = await DataBaseMethod().getChatRoom();

    setState(() {});
  }

  Widget chatRoomLile() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  int sendIndex = index;
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatRoomListTile(
                    lastMessage: ds["lastMessage"],
                    chatRoomId: ds.id,
                    myuserName: myUserName.toString(),
                    time: ds["lastMessageSendTs"],
                    index: index,
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
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
      backgroundColor: Color(0xFF7f30fe),
      body: SingleChildScrollView(
        child: Container(
          // margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: Column(
            children: [
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
                                    fontSize: 22.0,
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
                                color: Colors.white,
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
                            color: Colors.white,
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
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                )
                              : Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                  size: 30,
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
                            children: tempSearchStore.map(
                              (element) {
                                return buildResultCard(element);
                              },
                            ).toList(),
                          )
                        : chatRoomLile(),
                  ],
                ),
              ),
            ],
          ),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatsPage(
              name: data['Name'],
              profileur: data['Photo'],
              username: data['Username'],
            ),
          ),
        );
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

class chatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myuserName, time;
  int index;

  chatRoomListTile(
      {required this.lastMessage,
      required this.chatRoomId,
      required this.myuserName,
      required this.time,
      required this.index});

  @override
  State<chatRoomListTile> createState() => _chatRoomListTileState();
}

class _chatRoomListTileState extends State<chatRoomListTile> {
  // this function is call the getthe sharedpre method

  @override
  void initState() {
    // TODO: implement initState
    gethisUserInfo();
    applyRandomColor();
    super.initState();
  }

  String profirePicUrl = "", name = "", userName = "", id = "", chatRoomId = "";
  // this code is used to pic randowm color in colrors list and add background color in circleAvatar
  var colors = [
    Colors.blue.shade200,
    Colors.yellow.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    Colors.brown.shade200,
    Colors.teal.shade200,
    Colors.red.shade200,
    Colors.purple.shade200,
  ];
  var defaultColor = Colors.green.shade600;
  applyRandomColor() {
    var rrnd = Random().nextInt(colors.length);
    setState(() {
      defaultColor = colors[rrnd];
    });
  }

// this function are used to get the user information
  gethisUserInfo() async {
    userName = widget.chatRoomId
        .replaceAll("-", "")
        .replaceAll(widget.myuserName, " ");
    QuerySnapshot querySnapshot = await DataBaseMethod().getUserInfo(userName);
    name = "${querySnapshot.docs[0]["Name"]}";
    userName = "${querySnapshot.docs[0]["Username"]}";
    profirePicUrl = "${querySnapshot.docs[0]["Photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatsPage(
                name: userName,
                profileur: profirePicUrl,
                username: userName.toUpperCase(),
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 31,
              backgroundColor: defaultColor,
              child: Icon(
                Icons.person_2,
                size: 40,
                color: Colors.white,
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
                  userName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    widget.lastMessage,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
