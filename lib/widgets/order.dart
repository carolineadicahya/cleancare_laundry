import 'package:CleanCare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

enum OrderStatus { DITERIMA, DALAM_PENGERJAAN, SELESAI, CANCEL }

class Order extends StatelessWidget {
  Order({
    required this.email,
    required this.items,
    required this.orderDate,
    required this.status,
    required this.onDetail,
  });

  final String email;
  final List<Map<String, dynamic>> items;
  final DateTime orderDate;
  final OrderStatus status;
  final Function onDetail;

  // For formatting date
  final DateFormat formatter = DateFormat('dd MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(121.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color.fromRGBO(220, 233, 245, 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getOrderIconWidget(status),
          const SizedBox(
            width: 25.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getOrderStatusText(status),
                  style: const TextStyle(
                    color: Color.fromRGBO(19, 22, 33, 1),
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                textRow("Tanggal Order", orderDate as String),
                const SizedBox(
                  height: 5.0,
                ),
                textRow("Status", getOrderStatusText(status)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget textRow(String textOne, String textTwo) {
  return Wrap(
    children: [
      Text(
        "$textOne:",
        style: const TextStyle(
          color: Color.fromRGBO(74, 77, 84, 0.7),
          fontSize: 14.0,
        ),
      ),
      const SizedBox(
        width: 4.0,
      ),
      Text(
        textTwo,
        style: const TextStyle(
          color: Color.fromRGBO(19, 22, 33, 1),
          fontSize: 14.0,
        ),
      ),
    ],
  );
}

Widget getOrderIconWidget(OrderStatus status) {
  switch (status) {
    case OrderStatus.DITERIMA:
      return Container(
        width: ScreenUtil().setWidth(37.0),
        height: ScreenUtil().setHeight(37.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(93, 186, 235, 0.173),
        ),
        child: const Icon(
          Icons.local_activity,
          color: Constants.primaryColor,
        ),
      );
    case OrderStatus.DALAM_PENGERJAAN:
      return Container(
        width: ScreenUtil().setWidth(37.0),
        height: ScreenUtil().setHeight(37.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(238, 173, 133, 0.149),
        ),
        child: const Icon(
          Icons.history,
          color: Color.fromRGBO(255, 99, 2, 1),
        ),
      );
    case OrderStatus.SELESAI:
      return Container(
        width: ScreenUtil().setWidth(37.0),
        height: ScreenUtil().setHeight(37.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(126, 240, 126, 0.145),
        ),
        child: const Icon(
          Icons.history,
          color: Color.fromRGBO(50, 144, 12, 1),
        ),
      );
    case OrderStatus.CANCEL:
      return Container(
        width: ScreenUtil().setWidth(37.0),
        height: ScreenUtil().setHeight(37.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(245, 132, 103, 0.141),
        ),
        child: const Icon(
          Icons.history,
          color: Color.fromRGBO(255, 10, 2, 1),
        ),
      );
  }
}

String getOrderStatusText(OrderStatus status) {
  switch (status) {
    case OrderStatus.DITERIMA:
      return 'Pesanan Diterima';
    case OrderStatus.DALAM_PENGERJAAN:
      return 'Dalam Pengerjaan';
    case OrderStatus.SELESAI:
      return 'Pesanan Selesai';
    case OrderStatus.CANCEL:
      return 'Cancel';
  }
}
