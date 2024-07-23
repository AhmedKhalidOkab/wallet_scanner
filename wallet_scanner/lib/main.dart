import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_scanner/dio_helper.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:wallet_scanner/presentaions/home_qr/scan_of_points_screen.dart';
import 'package:wallet_scanner/presentaions/home_qr/scan_of_wallet_screen.dart';

void main() {
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  String? massage;
  bool ClientProfileloading = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(255, 99, 25, 1),
                centerTitle: true,
                title: const Text(
                  'Scanner',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              body: Builder(builder: (context) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: () {
                            _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                                context: context,
                                onCode: (code) {
                                  setState(() {
                                    print('${code}==========');

                                    scanTogetClientProfile(
                                        id: "$code", context: context);
                                  });
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                                height: 50.h,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(255, 99, 25, 1),
                                      width: 1.w),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                    child: Text(
                                  "Scan Wallet",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ))),
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                      InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: () {
                            _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                                context: context,
                                onCode: (code) {
                                  setState(() {
                                    print('${code}==========');
                                    scanTogetClientProfile(
                                        id: "$code",
                                        pointsScreen: true,
                                        context: context);
                                  });
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                                height: 50.h,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(255, 99, 25, 1),
                                      width: 1.w),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                    child: Text(
                                  "Scan Points",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ))),
                          )),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }

  Future<void> scanTogetClientProfile(
      {required BuildContext context,
      required String id,
      bool pointsScreen = false}) async {
    var data = FormData.fromMap({
      'id': id,
    });
    await DioHelper.dio
        .post(
            'https://admin.gulfsaudi.com/public/api/v1/client/getClientProfile',
            data: data)
        .then((value) {
      setState(() {
        value.data["status"] == true
            ? setState(() {
                print(
                    '${value.data["clients"]["id"]}==========================');
                pointsScreen == false
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => WalletScreen(
                              balance: value.data["clients"]["wallet_balance"],
                              name: value.data["clients"]["name"],
                              id: value.data["clients"]["id"],
                            )))
                    : Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => PointsScreen(
                            name: value.data["clients"]["name"],
                            phone: value.data["clients"]["phone"],
                            points: value.data["clients"]["points"])));
              })
            : ShowToast(
                msg: "The selected user is invalid.",
                states: ToastStates.ERROR);
      });
    }).catchError((onError) {
      setState(() {
        ClientProfileloading = false;
      });
      ShowToast(msg: onError.toString(), states: ToastStates.ERROR);
      print('${onError.toString()}rrrrrrrrrrrrrrrrrrrrr');
    });
  }
}
