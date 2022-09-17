import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newproject/authentication/model/servise.dart';
import 'package:newproject/authentication/repository/authentication_repository.dart';
import 'package:newproject/authentication/screens/signup.dart';
import 'package:newproject/component/const.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../authentication/repository/user_repo.dart';
import '../location_repository/location.dart';

class MyMap extends StatefulWidget {
  bool myService;
  Service service;
  MyMap({Key? key, required this.service, required this.myService})
      : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final dataBaseRef = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;
  LocationRepository locationRepository = LocationRepository();
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController googleMapController;
  Set<Marker> marker = {};
  Future<Uint8List> getBytesFromAssets(String path, int wid) async {
    ByteData data = await rootBundle.load(
      path,
    );
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: wid);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!
        .buffer
        .asUint8List();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(30.5852, 36.2384),
    zoom: 7,
  );
  @override
  void initState() {
    locationRepository.getUserLocation().then((value) {
      Provider.of<UserRepository>(context, listen: false)
          .getUserLocation(value!.latitude ?? -1, value.longitude ?? -1);
      Provider.of<UserRepository>(context, listen: false).getUser();
    });
    Provider.of<UserRepository>(context, listen: false).changeState(true);
    // Provider.of<UserRepository>(context, listen: false).getMyService();
    //Provider.of<UserRepository>(context, listen: false).getHelperUser();
    Future.delayed(const Duration(seconds: 2), () {
      loadMarker(
          widget.service.address.lat ?? 0, widget.service.address.log ?? 0);
    });
    Provider.of<UserRepository>(context, listen: false).fetchMyService();

    super.initState();
  }

  load() {
    setState(() {
      marker.add(Marker(
          icon: BitmapDescriptor
              .defaultMarker, //BitmapDescriptor.fromBytes(merkerIcon),
          markerId: const MarkerId('currentLocation'),
          position: LatLng(widget.service.address.lat ?? 0,
              widget.service.address.log ?? 0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<AuthenticationRepository>(context, listen: false)
        .currentUserId();
    // Provider.of<UserRepository>(context, listen: false).getMyService();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            widget.myService == false
                ? SlidingUpPanel(
                    parallaxEnabled: true,
                    maxHeight: size.height * 0.47,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    panelBuilder: (controller) => PanelWidget(
                      controller: controller,
                      service: widget.service,
                      myService: widget.myService,
                    ),
                    body: GoogleMap(
                      markers: marker,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) async {
                        String style = await DefaultAssetBundle.of(context)
                            .loadString('assets/map.json');
                        controller.setMapStyle(style);
                        _controller.complete(controller);
                        googleMapController = controller;
                      },
                    ),
                  )
                : GoogleMap(
                    markers: marker,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) async {
                      String style = await DefaultAssetBundle.of(context)
                          .loadString('assets/map.json');
                      controller.setMapStyle(style);
                      _controller.complete(controller);
                      googleMapController = controller;
                    },
                  ),
            if (widget.myService)
              MainAppBar(
                size: size,
                title: 'Me',
                onTap: () {
                  Provider.of<AuthenticationRepository>(context, listen: false)
                      .signOut();
                  Navigator.restorablePushNamed(context, "/login");
                },
                icon: const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 30),
                  child: Icon(
                    Icons.logout,
                    color: Colors.black26,
                  ),
                ),
              )
            else
              MainAppBar(
                size: size,
                title: 'Community',
                icon: const SizedBox(),
              ),
            // if (widget.myservice == false)
            //   Positioned(
            //       bottom: 0,
            //       left: 0,
            //       right: 0,
            //       child: Stack(
            //         children: [
            //           Container(
            //             width: double.infinity,
            //             decoration: BoxDecoration(
            //                 boxShadow: [
            //                   BoxShadow(
            //                       offset: const Offset(0, 0),
            //                       blurRadius: 17,
            //                       color: Colors.black.withAlpha(25))
            //                 ],
            //                 color: Colors.white,
            //                 borderRadius: const BorderRadius.only(
            //                     topLeft: Radius.circular(20),
            //                     topRight: Radius.circular(20))),
            //             height: size.height * 0.3,
            //             child: Column(
            //               children: [
            //                 Padding(
            //                   padding: EdgeInsets.only(
            //                       top: size.height * 0.11, bottom: 15),
            //                   child: Text(
            //                     widget.service.users!.name ?? '',
            //                     style: const TextStyle(fontSize: 32),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.only(
            //                     bottom: 9,
            //                   ),
            //                   child: Text(
            //                     widget.service.titel ?? '',
            //                     style: const TextStyle(fontSize: 24),
            //                   ),
            //                 ),
            //                 Text(
            //                   widget.service.users!.phone ?? '',
            //                   style: const TextStyle(fontSize: 24),
            //                 ),
            //                 // userId == widget.service.users!.id
            //                 //     ? ElevatedButton(
            //                 //         onPressed: () {}, child: Text('ACCEPTED'))
            //                 //     : ElevatedButton(
            //                 //         onPressed: () {}, child: Text('can Helpe'))
            //               ],
            //             ),
            //           ),
            //         ],
            //       )),
            Consumer<UserRepository>(
              builder: (context, controller, child) {
                if (widget.myService && controller.getHaveService) {
                  return Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(color: const Color(mainColor))),
                      height: size.height * 0.23,
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.service.users?.name ?? '',
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text(
                            widget.service.title ?? '',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02),
                            decoration: BoxDecoration(
                                color: const Color(mainColor),
                                borderRadius: BorderRadius.circular(15)),
                            child: FlipCard(
                              front: ListTile(
                                title: Text(
                                  widget.service.state == 1
                                      ? widget.service.help?.name ?? ''
                                      : 'Searching...',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  widget.service.state == 1
                                      ? widget.service.help?.phone ?? ''
                                      : 'Tekram..',
                                  style: const TextStyle(color: Colors.white60),
                                ),
                                trailing:
                                    Image.asset('assets/image/Group 36.png'),
                              ),
                              back: InkWell(
                                onTap: () {
                                  Provider.of<UserRepository>(context,
                                          listen: false)
                                      .deleteMyService();
                                },
                                child: const Center(
                                    child: Text(
                                  'Done',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            // if (widget.myservice == false && widget.service.state == 0)
            //   Positioned(
            //       left: 0,
            //       right: 0,
            //       bottom: 0,
            //       child: InkWell(
            //           onTap: () {
            //             Provider.of<UserRepository>(context, listen: false)
            //                 .canHelp(Service(
            //                     address: widget.service.address,
            //                     users: widget.service.users,
            //                     state: 1,
            //                     titel: widget.service.titel,
            //                     descreption: widget.service.descreption,
            //                     help: Provider.of<UserRepository>(context,
            //                             listen: false)
            //                         .helperUser));
            //           },
            //           child: Image.asset('assets/image/Group 51.png'))),
          ],
        ),
      ),
    );
  }

  void loadMarker(double latitude, double longitude) async {
    final Uint8List merkerIcon =
        await getBytesFromAssets('assets/image/المشروع-03 1.png', 120);

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 14)));
    // marker.clear();
    marker.add(Marker(
        icon: BitmapDescriptor.fromBytes(merkerIcon),
        markerId: const MarkerId('currentLocation'),
        position: LatLng(latitude, longitude)));

    setState(() {});
  }
}

class PanelWidget extends StatelessWidget {
  final bool myService;
  final Service service;
  final ScrollController controller;
  const PanelWidget(
      {Key? key,
      required this.controller,
      required this.service,
      required this.myService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserRepository>(context, listen: false).getHelperUser();
    var userId = Provider.of<AuthenticationRepository>(context, listen: false)
        .currentUserId();
    Size size = MediaQuery.of(context).size;
    return ListView(
      controller: controller,
      children: [
        if (userId == service.users!.id)
          Container(
            margin: const EdgeInsets.only(left: 15, top: 5, bottom: 40),
            child: const Text(
              'My urgent help request',
              style: TextStyle(color: Color(mainColor), fontSize: 25),
            ),
          ),
        if (userId != service.users!.id)
          ListTile(
              leading: Image.asset('assets/image/المشروع-03 1.png'),
              title: Text(
                service.users?.name ?? '',
                style: const TextStyle(fontSize: 22),
              ),
              subtitle: Text(
                service.title ?? '',
                style: const TextStyle(fontSize: 17),
              ),
              trailing: myService == false && service.state == 0
                  ? InkWell(
                      onTap: () {
                        Provider.of<UserRepository>(context, listen: false)
                            .canHelp(
                          Service(
                            userUID: FirebaseAuth.instance.currentUser!.uid,
                            address: service.address,
                            users: service.users,
                            state: 1,
                            title: service.title,
                            description: service.description,
                            help: Provider.of<UserRepository>(
                              context,
                              listen: false,
                            ).helperUser,
                          ),
                          service.userUID,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/image/Group 53.png'),
                    )
                  : const SizedBox()),
        Container(
          margin: EdgeInsets.only(left: size.width * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userId == service.users!.id)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Title :  ${service.title ?? ''}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              const Text(
                'Description :',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    right: size.width * 0.16, top: 10, bottom: 10),
                padding: const EdgeInsets.all(8),
                height: size.height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(mainColor),
                    )),
                child: Text(
                  service.description ?? 'no description',
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.phone_android_outlined,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    service.users?.phone ?? '',
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
