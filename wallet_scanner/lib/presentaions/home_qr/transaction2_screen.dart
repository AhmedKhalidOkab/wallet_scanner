import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_scanner/dio_helper.dart';
import 'package:wallet_scanner/main.dart';
import 'package:wallet_scanner/presentaions/home_qr/scan_of_wallet_screen.dart';
import 'package:image_picker/image_picker.dart';

class Transaction2Screen extends StatefulWidget {
  Transaction2Screen({super.key, required this.phone, required this.name});
  String phone;
  String name;

  @override
  State<Transaction2Screen> createState() => _Transaction2ScreenState();
}

class _Transaction2ScreenState extends State<Transaction2Screen> {
  TextEditingController amountController = TextEditingController();

  bool loading = false;
  File? image = File('');
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
                height: 150.h,
              ),
              Text(
                "Enter the Total Amount ",
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
                hintText: '3',
                validator: () {},
              ),
              SizedBox(
                height: 30.h,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pickImageFromGallery();
                  });
                },
                child: Container(
                  height: 50.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(255, 99, 25, 1), width: 1.w),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: image != null && image!.path != ''
                      ? Image.file(image!)
                      : Text(
                          'Click here to take a photo',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 99, 25, 1),
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    image!.path == '' || amountController.text == null
                        ? ShowToast(
                            msg: 'Enter the photo and amount',
                            states: ToastStates.ERROR)
                        : ScanToGetPoints(
                            amount: amountController.text,
                            image: image!.path,
                            phone: widget.phone,
                          );
                  });
                },
                child: Container(
                  height: 50.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Color.fromRGBO(255, 99, 25, 1)),
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Center(
                          child: Text(
                            'send',
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

  Future<void> ScanToGetPoints({
    String? phone,
    String? amount,
    String? image,
  }) async {
    setState(() {
      loading = true;
    });
    var data = FormData.fromMap({
      'phone': phone,
      'amount': amount,
      'image': [
        await MultipartFile.fromFile(
          image!,
        )
      ],
    });
    await DioHelper.dio
        .post(
            'https://admin.gulfsaudi.com/public/api/v1/client/ScanToGetPoints',
            data: data)
        .then((value) {
      setState(() {
        loading = false;
      });

      ShowToast(
          msg:
              value.data["status"] == true && value.data["message"] == "Success"
                  ? 'The payment was successful'
                  : '${value.data["message"]}',
          states:
              value.data["status"] == true && value.data["message"] == "Success"
                  ? ToastStates.SUCCESS
                  : ToastStates.ERROR);

      value.data["status"] == true && value.data["message"] == "Success"
          ? Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => MyApp()))
          : null;
    }).catchError((onError) {
      print('${onError}');
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  }
}
