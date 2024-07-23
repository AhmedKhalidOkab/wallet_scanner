import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://admin.gulfsaudi.com/public',
        headers: {
          'Accept': 'application/json',
        },
        receiveDataWhenStatusError: true,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
  }

  static Future<void> addToken(String token) async {
    dio.options.headers.addAll({
      'Authorization': 'Bearer $token',
    });
  }

  static Future<Response> getData({
    required url,
    Map<String, dynamic>? qurey,
  }) async {
    return await dio.get(url, queryParameters: qurey);
  }

  static Future<Response> getLoggedUserData({
    required url,
    String? token,
    Map<String, dynamic>? qurey,
  }) async {
    var headers = {"Authorization": (token != null) ? "Bearer $token" : ''};

    dio.options.headers.addAll(headers);

    return await dio.get(url, queryParameters: qurey);
  }

  static Future<Response> postData({
    required String url,
    FormData? formData,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    return dio.post(
      url,
      queryParameters: query,
      data: formData ?? data,
    );
  }

  static Future<Response> postLoggedUser({
    required String url,
    String? token,
    FormData? formData,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    var headers = {
      'Authorization': 'Bearer $token',
    };
    // var headers = {"Authorization": (token != null) ? "Bearer $token" : ''};

    dio.options.headers.addAll(headers);
    return dio.post(
      url,
      data: formData ?? data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'ar',
    String? token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };

    return dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static void removeToken() {
    dio.options.headers.remove('Authorization');
  }

  // }
}

class TextFormFiled extends StatelessWidget {
  TextFormFiled(
      {Key? key,
      this.readOnly,
      required this.controller,
      this.obscureText,
      this.textInputType,
      required this.validator,
      this.prefixIcon,
      this.contentPadding,
      required this.hintText,
      this.suffixIcon,
      this.maxLines,
      this.minLines,
      this.onChanged,
      this.maxLength,
      this.onFieldSubmitted})
      : super(key: key);
  final bool? readOnly;
  final TextEditingController controller;
  final bool? obscureText;
  final TextInputType? textInputType;
  final Function validator;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final String hintText;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  void Function(String)? onChanged;
  void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      // cursorHeight: 15.sp,
      controller: controller,
      obscureText: obscureText!,
      cursorColor: Color.fromRGBO(255, 99, 25, 1),
      keyboardType: textInputType,
      validator: (value) => validator(value),
      maxLines: maxLines,
      minLines: minLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        // contentPadding: contentPadding ??
        //     EdgeInsets.symmetric(horizontal: 0.h, vertical: 0.h),
        filled: true,
        suffixIcon: suffixIcon ?? null,
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black45,
          fontFamily: 'Almarai',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide:
              BorderSide(color: Color.fromRGBO(231, 231, 230, 1), width: 1.sp),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide:
              BorderSide(color: Color.fromRGBO(231, 231, 230, 1), width: 1.sp),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide:
              BorderSide(color: Color.fromRGBO(255, 99, 25, 1), width: 1.sp),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide:
              BorderSide(color: Color.fromRGBO(231, 231, 230, 1), width: 1.sp),
        ),
      ),
    );
  }
}
