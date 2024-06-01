import 'package:chatapp/page/home.dart';
import 'package:chatapp/service/database.dart';
import 'package:chatapp/service/shared_prefirences.data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChatsPage extends StatefulWidget {
  String name, profileur, username;

  ChatsPage(
      {required this.name, required this.profileur, required this.username});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  TextEditingController messageController = new TextEditingController();
  String? myName, myProfilePic, myUserName, myEmail, massageId, chatRoomId;
  Stream? messageStream;

  getthesharedpre() async {
    myUserName = await SharedPreferenceHelper().getUserNeme();
    myName = await SharedPreferenceHelper().getUserDisplay();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    chatRoomId = getChatRoomIdbyusername(widget.username, myUserName!);
  }

  ontheload() async {
    await getthesharedpre();
    await getAndSetMassages();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ontheload();
  }

  getChatRoomIdbyusername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget chatMassageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight:
                    sendByMe ? Radius.circular(0) : Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: sendByMe ? Radius.circular(0) : Radius.circular(24),
              ),
              color: sendByMe
                  ? Color.fromARGB(255, 185, 207, 246)
                  : Color.fromARGB(255, 219, 219, 219),
            ),
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMassage() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 90.0, top: 130),
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return chatMassageTile(
                      ds["massage"],
                      myUserName == ds["sendBy"],
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                  reverse: true,
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  addMessage(bool sendClicked) {
    if (messageController.text != "") {
      String massage = messageController.text;
      messageController.text = "";
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mma').format(now);

      Map<String, dynamic> massageInfoMap = {
        "massage": massage,
        "sendBy": myUserName,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myProfilePic,
      };
      massageId ??= randomAlphaNumeric(10);

      DataBaseMethod().addMassage(chatRoomId!, massageId!, massageInfoMap).then(
        (value) {
          Map<String, dynamic> listMasseageInfoMap = {
            "lastMessage": massage,
            "lastMessageSendTs": formattedDate,
            "time": FieldValue.serverTimestamp(),
            "lastMessageSendBy": myUserName,
          };
          DataBaseMethod()
              .updataLastMessageSend(chatRoomId!, listMasseageInfoMap);
          if (sendClicked) {
            massageId = "";
          }
        },
      );
    }
  }

  getAndSetMassages() async {
    messageStream = await DataBaseMethod().getChatRoomMassages(chatRoomId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7f30fe),
      body: Container(
        margin: EdgeInsets.only(
          top: 50.0,
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: chatMassage(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type a message",
                      hintStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: 18,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          addMessage(true);
                        },
                        child: Icon(Icons.send_rounded),
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
  }
}
