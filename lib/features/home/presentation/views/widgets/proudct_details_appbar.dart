import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/colors.dart';
class ProductDetailsAppBar extends StatelessWidget {
  const ProductDetailsAppBar({
    super.key, this.discount,
  });
  final int? discount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12,),
      child: Center(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color3,
              maxRadius: 25,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(width: MediaQuery.sizeOf(context).width*0.15,),
             Text(
              'Explore Details',
              style: TextStyle(
                color: color4,
                fontFamily: 'DancingScript',
                fontSize: 23.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
          discount==0?  const SizedBox():

          Container(
              width: 100.w,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(
                  5,
                ),
                color: Colors.greenAccent,
              ),
              child:  Center(
                child: Text(
                  'Sale - $discount %',
                  style:  TextStyle(
                    color: color4,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DancingScript',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}