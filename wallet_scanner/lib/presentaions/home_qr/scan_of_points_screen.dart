import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wallet_scanner/dio_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet_scanner/presentaions/home_qr/transaction2_screen.dart';
import 'package:wallet_scanner/presentaions/transaction_screen.dart';

class PointsScreen extends StatefulWidget {
  PointsScreen(
      {super.key,
      required this.name,
      required this.points,
      required this.phone});
  String name;
  int points;
  String phone;
  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  TextEditingController moneyController = TextEditingController();
  TextEditingController passowrdController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: Positioned(
            right: 0,
            left: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 80.h,
                width: double.infinity,
                // color: MyColors.backgroundColor,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w).h,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 35.h,
                        width: 36.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color: Color.fromRGBO(255, 99, 25, 1))),
                        child: Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 7, left: 7).w,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color.fromRGBO(255, 99, 25, 1),
                                  size: 24,
                                ))),
                      )),
                ),
              ),
            ),
          ),
          title: Text(
            "points",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  border: Border.all(
                      color: Color.fromRGBO(255, 99, 25, 1), width: 1.w),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Client Name :',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 99, 25, 1),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  border: Border.all(
                      color: Color.fromRGBO(255, 99, 25, 1), width: 1.w),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Points :',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "${widget.points}",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 99, 25, 1),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              gasContainer(name: 'Diesel'),
              SizedBox(
                height: 20.h,
              ),
              gasContainer(name: 'Gasoline 91'),
              SizedBox(
                height: 20.h,
              ),
              gasContainer(name: 'Gasoline 95'),
            ],
          ),
        ),
      ),
    );
  }

  Widget gasContainer({String? name}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Transaction2Screen(
                  phone: widget.phone,
                  name: name,
                )));
      },
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          color: Color.fromRGBO(255, 99, 25, 1),
        ),
        child: Center(
          child: Text(
            name!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> scanToGetUserId({required String id, amount, password}) async {
  //   var data = FormData.fromMap(
  //       {'client_id': id, 'amount': amount, 'password': password});
  //   await DioHelper.dio
  //       .post(
  //           'https://admin.gulfsaudi.com/public/api/v1/client/scanToPayToStationFromWallet',
  //           data: data)
  //       .then((value) {
  //     setState(() {
  //       loading = false;
  //     });

  //     ShowToast(
  //         msg: value.data["status"] == true
  //             ? 'تمت العمليه بنجاح'
  //             : value.data["errors"]["client_id"][0] != null
  //                 ? "The selected code is invalid."
  //                 : value.data["errors"]["amount"][0] != null
  //                     ? "The selected amount is invalid."
  //                     : value.data["errors"]["password"][0] != null
  //                         ? " password is not correct."
  //                         : '',
  //         states: value.data["status"] == true
  //             ? ToastStates.SUCCESS
  //             : ToastStates.ERROR);
  //   }).catchError((onError) {
  //     setState(() {
  //       loading = false;
  //     });
  //     ShowToast(msg: onError, states: ToastStates.ERROR);
  //     print('${onError.toString()}rrrrrrrrrrrrrrrrrrrrr');
  //   });
  // }
}
