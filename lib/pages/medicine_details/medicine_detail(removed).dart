import 'package:flutter/material.dart';
import 'package:med_care/constants.dart';
import 'package:med_care/global_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/medicine.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {Key? key}) : super(key: key);
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  
  @override
  Widget build(BuildContext context) {
    // var medicine;
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(3.h),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine),
            ExtendedSections(medicine: widget.medicine),
            Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  //open alert dialog box + global bloc
                  openAlertBox(context,_globalBloc);
                },
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: kScaffoldColor,
                      ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context,GlobalBloc _globalBloc) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kScaffoldColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
          contentPadding: EdgeInsets.only(top: 1.h),
          title: Text(
            'Delete This Reminder',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () {
                // global bloc to delete med
                _globalBloc.removeMedicine(widget.medicine);
                Navigator.popUntil(context,ModalRoute.withName('/'));
              },
              child: Text(
                'Ok',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: kSecondaryColor,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ExtendedSections extends StatelessWidget {
  const ExtendedSections({super.key, this.medicine});
  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine',      
          fieldInfo: medicine!.medicineType! == 'None'
          ? 'Not Specified':
          medicine!.medicineType!,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dose Interval',
          fieldInfo: 'Every ${medicine!.interval} hours | ${medicine!.interval == 24 ? "One time a day" : "${(24/medicine!.interval!).floor()} times a day"}'
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo: '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}',
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              fieldTitle,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: kSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({super.key, this.medicine});
  final Medicine? medicine;
  Hero makeIcon(double size) {
    if (medicine!.medicineType == 'Syrup') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Image.asset(
          'assets/images/syrup.png',
          //color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'Pill') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Image.asset(
          'assets/images/pills.png',
          //color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'Syringe') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Image.asset(
          'assets/images/syringe.png',
          //color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'Capsule') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Image.asset(
          'assets/images/capsule.png',
          //color: kOtherColor,
          height: 7.h,
        ),
      );
    }

    //incase of no medicine type
    return Hero(
      tag: medicine!.medicineName! + medicine!.medicineType!,
      child: Icon(
        Icons.error,
        color: kOtherColor,
        size: size,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        makeIcon(7.h),
        SizedBox(
          width: 2.w,
        ),
        Column(
          children: [
            Hero(
              tag: medicine!.medicineName!,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                    fieldTitle: 'Medicine Name',
                    fieldInfo: medicine!.medicineName!),
              ),
            ),
            MainInfoTab(
                fieldTitle: 'Dosage',
                fieldInfo: medicine!.dosage == 0
                    ? 'Not Specified'
                    : "${medicine!.dosage} mg"),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.h,
      height: 10.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Text(
              fieldTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
