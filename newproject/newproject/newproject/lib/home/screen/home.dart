import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:newproject/authentication/repository/user_repo.dart';
import 'package:newproject/authentication/screens/signup.dart';
import 'package:newproject/component/const.dart';
import 'package:newproject/map/screen/map.dart';
import 'package:provider/provider.dart';

import '../../authentication/model/servise.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var databaceRef = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    Provider.of<UserRepository>(context, listen: false).changeState(false);
    databaceRef = FirebaseDatabase.instance.ref();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Consumer<UserRepository>(
          builder: (context, value, child) {
            return Column(
              children: [
                MainAppBar(
                  size: size,
                  title: 'Community',
                  icon: const SizedBox(),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: databaceRef.child('Services').onValue,
                      builder:
                          (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                        if (snapshot.data?.snapshot.value == null) {
                          return Container(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/image/Artboard 51-01.png',
                                  color: Colors.grey,
                                  width: size.width * 0.15,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'There is nothing about an urgent help \nrequest yet.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                )
                              ],
                            ),
                          );
                        } else if (snapshot.hasData) {
                          List<Service> services = [];

                          var data = snapshot.data!.snapshot.value as Map;
                          data.forEach((key, value) {
                            services.add(Service.fromJson(value));
                          });
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyMap(
                                                myService: false,
                                                service: services[index],
                                              )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: size.width * 0.05,
                                      right: size.width * 0.05,
                                      bottom: size.height * 0.02),
                                  decoration: BoxDecoration(
                                      color: services[index].state == 1
                                          ? const Color(mainColor)
                                          : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 4),
                                            blurRadius: 4,
                                            color: Colors.black.withAlpha(25))
                                      ],
                                      borderRadius: BorderRadius.circular(19),
                                      border: Border.all(
                                          color: const Color(mainColor))),
                                  child: ListTile(
                                    leading: Image.asset(
                                      services[index].state == 1
                                          ? 'assets/image/Group 36.png'
                                          : 'assets/image/المشروع-03 1.png',
                                    ),
                                    title: Text(
                                      services[index].users?.name ?? '',
                                      style: TextStyle(
                                          color: services[index].state == 1
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    subtitle: Text(services[index].title ?? '',
                                        style: TextStyle(
                                            color: services[index].state == 1
                                                ? Colors.white
                                                : Colors.black38)),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ],
            );
          },
        ),
      ],
    ));
  }
}
