// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:wls_pos/home/models/response/UserMenuApiResponse.dart';
// import 'package:wls_pos/utility/widgets/wls_pos_scaffold.dart';
// import 'package:wls_pos/utility/wls_pos_color.dart';
// import 'package:wls_pos/utility/wls_pos_screens.dart';
//
// class ScratchScreen extends StatefulWidget {
//   List<MenuBeanList>? scratchList;
//
//   ScratchScreen({Key? key, this.scratchList}) : super(key: key);
//
//   @override
//   _ScratchScreenState createState() => _ScratchScreenState();
// }
//
// class _ScratchScreenState extends State<ScratchScreen> {
//   bool _mIsDrawerVisible = true;
//
//   // List<String> imageUrls = [
//   //   'assets/scratch/sale_ticket.png',
//   //   'assets/scratch/ticket_validation.png',
//   //   'assets/scratch/icon_quick_order.png',
//   //   'assets/scratch/book_receive.png',
//   //   'assets/scratch/inventory_report.png',
//   //   'assets/scratch/book_activation.png',
//   //   'assets/scratch/pack_return.png',
//   //   'assets/scratch/pack_return.png',
//   //   'assets/scratch/inventory_flow_report.png',
//   // ];
//
//   @override
//   Widget build(BuildContext context) {
//     return WlsPosScaffold(
//       showAppBar: true,
//       centerTitle: false,
//       appBarTitle: const Text("Scratch"),
//       body: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             childAspectRatio: 0.8,
//             crossAxisCount: 2,
//           ),
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           itemCount: widget.scratchList?.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Ink(
//               decoration: const BoxDecoration(
//                 color: WlsPosColor.white,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: WlsPosColor.warm_grey_six,
//                     blurRadius: 2.0,
//                   ),
//                 ],
//               ),
//               child: InkWell(
//                 onTap: () {
//                   moveToNextScreen(widget.scratchList![index]);
//                   // print(homeModuleList[index]?[0]);  // Use to acquire index
//                   // print(jsonEncode(homeModuleList[index]?[0])); // Use to acquire index value
//                   // print("tap on index $index");
//                   // if (index == 0) {
//                   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //     content: Text("Index --> $index \n ${jsonEncode(homeModuleList[index]?[0])}"),
//                   //   ));
//                   // } else {
//                   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //     content: Text("Index --> $index \n ${jsonEncode(homeModuleList[index]?[1])}"),
//                   //   ));
//                   // }
//                 },
//                 customBorder: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Ink(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         width: 100,
//                         height: 100,
//                         "assets/scratch/${widget.scratchList?[index].caption}.png",
//                         errorBuilder: (context, object, stackTrace) {
//                           return Image.asset(
//                               width: 100,
//                               height: 100,
//                               "assets/icons/icon_confirmation.png");
//                         },
//                         // homeModuleCodesList.contains(homeModuleList[index]?[0].moduleCode)
//                         //     ? "assets/icons/${homeModuleList[index]?[0].moduleCode}.png"
//                         // imageUrls[index]
//                       ).p8(),
//                       // Text(homeModuleList[index]?[0].displayName ?? "NA", style: const TextStyle(color: WlsPosColor.black, fontWeight: FontWeight.bold))
//                       Text(widget.scratchList?[index].caption ?? "NA",
//                           style: const TextStyle(
//                               color: WlsPosColor.black,
//                               fontWeight: FontWeight.bold))
//                     ],
//                   ),
//                 ),
//               ),
//             ).p(6);
//           }).p(10),
//     );
//   }
//
//   void moveToNextScreen(MenuBeanList? menuBeanList) {
//     print("Screen Open--------------->${menuBeanList?.menuCode}");
//     String screenName;
//     switch (menuBeanList?.menuCode) {
//       case "SCRATCH_SALE":
//         screenName = WlsPosScreen.saleTicketScreen;
//         break;
//       case "SCRATCH_WIN_CLAIM":
//         screenName = WlsPosScreen.ticketValidationAndClaimScreen;
//         break;
//       case "SCRATCH_ORDER_BOOK":
//         screenName = WlsPosScreen.packOrderScreen;
//         break;
//       case "SCRATCH_RECEIVE_BOOK":
//         screenName = WlsPosScreen.packReceiveScreen;
//         break;
//       case "M_SCRATCH_INV_REPORT":
//         screenName = WlsPosScreen.inventoryReportScreen;
//         break;
//       case "SCRATCH_ACTIVATE_BOOK":
//         screenName = WlsPosScreen.packActivationScreen;
//         break;
//       case "SCRATCH_RETURN_BOOK":
//         screenName = WlsPosScreen.packReturnScreen;
//         break;
//       case "M_SCRATCH_INV_SUMMARY_REPORT":
//         screenName = WlsPosScreen.inventoryFlowScreen;
//         break;
//       default:
//         screenName = WlsPosScreen.qrScanScreen;
//     }
//     Navigator.pushNamed(context, screenName, arguments: menuBeanList);
//   }
// }
