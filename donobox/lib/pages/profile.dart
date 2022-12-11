import 'package:donobox/pages/editprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:donobox/pages/main.dart';
import 'package:donobox/pages/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../drawer/sidebar.dart';
import 'package:donobox/pages/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:donobox/model/profile.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Profile>> fetchProfile() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get('https://pbp-c04.up.railway.app/profile/json');

    // melakukan konversi data json menjadi object MyNotification
    List<Profile> listProfile = [];
    print(response);
    for (var d in response) {
      if (d != null) {
        listProfile.add(Profile.fromJson(d));
      }
    }
    return listProfile;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3F4E4F),
          title: const Text('Profile'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.notifications_active,
                color: Color(0xFF879999),
                size: 30,
              ),
              tooltip: 'Notification',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          ],
        ),
        drawer: drawer(),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding : EdgeInsets.fromLTRB(30, 40, 30, 40),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'),
                  radius: 60,
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder(
                  future: fetchProfile(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return Column(
                          children: const [
                            Text(
                              "Tidak ada data!",
                              style:
                              TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) =>
                            Column(
                              children: [
                                if (snapshot.data![index].fields.bio != null)
                                    Text("'${snapshot.data![index].fields.bio}'",
                                      style: TextStyle(
                                          color: Color(0xFF879999),
                                          letterSpacing: 2
                                      ),
                                    ),
                                    SizedBox(height: 40),

                                Text(
                                  'Saldo',
                                  style: TextStyle(
                                      color: Color(0xFF879999),
                                      letterSpacing: 2
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rp.${snapshot.data![index].fields.saldo}",
                                      style: TextStyle(
                                          color: Color(0xFF879999),
                                          letterSpacing: 1,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: Color(0xFF879999),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${snapshot.data![index].fields.role}",
                                      style: TextStyle(
                                          color: Color(0xFF879999),
                                          fontSize: 18,
                                          letterSpacing: 1
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.email,
                                      color: Color(0xFF879999),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (snapshot.data![index].fields.email != null)
                                      Text(
                                        "${snapshot.data![index].fields.email}",
                                        style: TextStyle(
                                            color: Color(0xFF879999),
                                            fontSize: 18,
                                            letterSpacing: 1
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.cake,
                                      color: Color(0xFF879999),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (snapshot.data![index].fields.birthday != null)
                                      Text(
                                        "${snapshot.data![index].fields.birthday}",
                                        style: TextStyle(
                                            color: Color(0xFF879999),
                                            fontSize: 18,
                                            letterSpacing: 1
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      color: Color(0xFF879999),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (snapshot.data![index].fields.phone != null)
                                      Text(
                                        "${snapshot.data![index].fields.phone}",
                                        style: TextStyle(
                                            color: Color(0xFF879999),
                                            fontSize: 18,
                                            letterSpacing: 1
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 100),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FloatingActionButton.extended(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const EditProfilePage()),
                                        );
                                      },
                                      heroTag: 'editprofile',
                                      elevation: 0,
                                      label: const Text("Edit Profile"),
                                      icon: const Icon(Icons.person_add_alt_1),
                                        backgroundColor: Color(0xFF3F4E4F),
                                    ),
                                    const SizedBox(width: 16.0),
                                    FloatingActionButton.extended(
                                      onPressed: () {},
                                      heroTag: 'mesage',
                                      elevation: 0,
                                      backgroundColor: Color(0xFF3F4E4F),
                                      label: const Text("Tambah Saldo"),
                                      icon: const Icon(Icons.money),
                                    ),
                                  ],
                                ),
                              ],
                            )
                            //     InkWell(
                            //     child: Container(
                            //         margin: const EdgeInsets.symmetric(
                            //             horizontal: 16, vertical: 12),
                            //         padding: const EdgeInsets.all(20.0),
                            //         decoration: BoxDecoration(
                            //           color: Colors.white,
                            //           borderRadius: BorderRadius.circular(10.0),
                            //         ),
                            //         child: Row(
                            //           children: [
                            //             Text("${snapshot.data![index].fields.role}",
                            //                 style: const TextStyle(
                            //                   fontSize: 18.0,
                            //                   fontWeight: FontWeight.bold,
                            //                 )),
                            //           ],
                            //         )
                            //     )
                            // )
                        );
                      }
                    }
                  }
              ),
            ),

        ],
        )


    );
  }
}