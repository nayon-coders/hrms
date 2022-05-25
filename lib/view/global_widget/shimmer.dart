import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  const ShimmerLoading({Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: appColors.gray200,
      highlightColor: appColors.white,
      child: Container(width: width,height: height, 
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(1)
        ),
      ),
    );
  }
}
