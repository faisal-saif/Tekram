// import 'package:flutter/material.dart';
// import 'package:newproject/authentication/model/servise.dart';
// import 'package:newproject/map/screen/map.dart';

// import 'package:provider/provider.dart';

// import '../../authentication/repository/user_repo.dart';

// class MyService extends StatelessWidget {
//   const MyService({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Provider.of<UserRepository>(context, listen: false).getMyService();
//     return Scaffold(body: Consumer<UserRepository>(
//       builder: (context, value, child) {
//         if (value.myServices != null) {
//           return InkWell(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => MyMap(
//                           service: value.myServices ??
//                               Service(address: value.myServices!.address))));
//             },
//             child: ListTile(
//               title: Text(value.myServices?.titel ?? '-'),
//               subtitle: Text(value.myServices?.descreption ?? '-'),
//             ),
//           );
//         }
//         return Text('I dont need helpe yet');
//         // return ListView.builder(
//         //   itemCount: value.myServices.length,
//         //   itemBuilder: (context, index) {
//         //     return InkWell(
//         //       onTap: () {},
//         //       child: ListTile(
//         //         leading: Image.asset(
//         //           'assets/image/megaphone.png',
//         //           width: 35,
//         //         ),
//         //         title: Text(value.myServices[index].titel ?? ''),
//         //         subtitle: Text(value.myServices[index].descreption ?? ''),
//         //       ),
//         //     );
//         //   },
//         // );
//       },
//     ));
//   }
// }
