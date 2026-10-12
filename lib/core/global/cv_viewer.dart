import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../core/global/custom_back_button.dart';
import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class CvViewerScreen extends StatelessWidget {
  final String cvUrl;
  final String applicantName;

  const CvViewerScreen({
    super.key,
    required this.cvUrl,
    required this.applicantName,
  });

  bool get isPdf {
    final url = cvUrl.toLowerCase().split('?').first;
    return url.endsWith('.pdf');
  }

  bool get isImage {
    final url = cvUrl.toLowerCase().split('?').first;

    return url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.webp') ||
        url.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: const CustomBackButton(),
        title: CustomText(
          "CV",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.blackColor,
        ),
        centerTitle: true,
      ),
      body: _buildViewer(),
    );
  }

  Widget _buildViewer() {
    if (isPdf) {
      return SfPdfViewer.network(
        cvUrl,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      );
    }

    if (isImage) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: cvUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            placeholder: (context, url) {
              return const Center(child: CircularProgressIndicator());
            },
            errorWidget: (context, url, error) {
              return _buildError();
            },
          ),
        ),
      );
    }

    return _buildUnsupportedFormat();
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 12.h),
            CustomText(
              "Unable to load CV",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            CustomText(
              "Please check the CV file or try again.",
              fontSize: 13,
              color: Colors.grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedFormat() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_drive_file_outlined,
              size: 56.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            CustomText(
              "Unsupported CV format",
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            CustomText(
              "This CV format cannot be previewed.",
              fontSize: 13,
              color: Colors.grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
