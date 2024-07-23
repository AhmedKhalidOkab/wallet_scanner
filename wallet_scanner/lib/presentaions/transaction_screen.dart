import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_scanner/dio_helper.dart';
import 'package:wallet_scanner/main.dart';
import 'package:wallet_scanner/presentaions/home_qr/scan_of_wallet_screen.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({super.key, required this.name, required this.id});
  String name;

  int id;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController amountController = TextEditingController();

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
            widget.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.h,
              ),
              Text(
                "Enter the Total amount you want to deduct ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFormFiled(
                readOnly: false,
                maxLines: 1,
                minLines: 1,
                textInputType: TextInputType.phone,
                obscureText: false,
                controller: amountController,
                hintText: '25 SAR',
                validator: () {},
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (amountController.text.isNotEmpty) {
                    setState(() {
                      scanToPayToStationFromWallet(sendData: {
                        'client_id': widget.id,
                        'amount': amountController.text,
                      });

                      loading = true;
                    });
                  } else {
                    ShowToast(
                        msg: "Enter the Total amount Please !",
                        states: ToastStates.ERROR);
                  }
                },
                child: Container(
                  height: 50.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Color.fromRGBO(255, 99, 25, 1)),
                  child: Center(
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanToPayToStationFromWallet(
      {Map<String, dynamic>? sendData}) async {
    var data = FormData.fromMap(sendData!);
    await DioHelper.dio
        .post(
            'https://admin.gulfsaudi.com/public/api/v1/client/scanToPayToStationFromWallet',
            data: data)
        .then((value) {
      setState(() {
        loading = false;
      });

      // ShowToast(
      //     msg: value.data["status"] == true &&
      //             value.data["message"] == "عملية التحويل تمت بنجاح"
      //         ? 'The payment was successful'
      //         : '${value.data["message"]}',
      //     states: value.data["status"] == true &&
      //             value.data["message"] == "عملية التحويل تمت بنجاح"
      //         ? ToastStates.SUCCESS
      //         : ToastStates.ERROR);

      value.data["status"] == true &&
              value.data["message"] == "عملية التحويل تمت بنجاح"
          ? AwesomeDialog(
              dismissOnTouchOutside: false,
              btnOkText: 'ok',
              context: context,
              dialogType: DialogType.noHeader,
              btnOkColor: Color.fromRGBO(255, 99, 25, 1),
              buttonsTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 20),
              animType: AnimType.rightSlide,
              title: 'The payment was successful',
              btnOkOnPress: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => MyApp()));
              },
            ).show()
          : AwesomeDialog(
              dismissOnTouchOutside: false,
              btnOkText: 'ok',
              context: context,
              dialogType: DialogType.noHeader,
              btnOkColor: Color.fromRGBO(255, 99, 25, 1),
              buttonsTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 20),
              animType: AnimType.rightSlide,
              title: '${value.data["message"]}',
              btnOkOnPress: () {
                Navigator.of(context).pop();
              },
            ).show();
    }).catchError((onError) {
      print('${onError}');
    });
  }
}
