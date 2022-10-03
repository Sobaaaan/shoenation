import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/screens/login_page.dart';
import 'package:flutter_authentication/utils/fire_auth.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: ('All Posts'),
                    ),
                    Tab(text: ('Profile')),
                  ],
                ),
                title: Text("MS Global"),
                backgroundColor: Colors.red,
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.search,
                      size: 2.0,
                    ),
                  ),
                ],
              ),
              body: TabBarView(
                children: [
                  Center(
                    // Use future builder and DefaultAssetBundle to load the local JSON file
                    child: FutureBuilder(
                      future: DefaultAssetBundle.of(context)
                          .loadString('assets/sample.json'),
                      builder: (context, snapshot) {
                        // Decode the JSON
                        var new_data = json.decode(snapshot.data.toString());

                        return ListView.builder(
                          // Build the ListView
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    // Text("Number: " + new_data[index]['userId']),
                                    // SizedBox(height: 10,),
                                    // Text("Name: " + new_data[index]['id']),
                                    // SizedBox(height: 10,),
                                    // Text( new_data[index]['title']),
                                    // SizedBox(height: 10,),
                                    const Text(
                                      'Title',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(new_data[index]['body'])
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: new_data == null ? 0 : new_data.length,
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'NAME: ${_currentUser.displayName}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'EMAIL: ${_currentUser.email}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        _isSigningOut
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isSigningOut = true;
                                  });
                                  await FirebaseAuth.instance.signOut();
                                  setState(() {
                                    _isSigningOut = false;
                                  });
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text('Sign out'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.red,
                onPressed: () {},
              ))),
    );
  }
}
