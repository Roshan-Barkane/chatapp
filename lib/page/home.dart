import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool search = false;
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateState(value) {
    if (value.toString().length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: Container(
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search User",
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            style: TextStyle(
                              color: Colors.black,
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
                        child: Icon(
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
                  Row(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Rosha Barkane",
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
            )
          ],
        ),
      ),
    );
  }
}
