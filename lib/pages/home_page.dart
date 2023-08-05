import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:matcher/matcher.dart';
import 'package:med_care/constants.dart';
import 'package:med_care/global_bloc.dart';
import 'package:med_care/pages/new_entry/new_entry_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/medicine.dart';
import 'medicine_details/medicine_details.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      //   appBar: AppBar(
      //     backgroundColor:kAppBarColor,
      //     // shadowColor: Colors.lightBlue,
      //     elevation: 5,
      //     title: Center(
      //       child: Text(
      //         'Med_Care',
      //         style: GoogleFonts.mulish(
      //           color: kAppBarTextColor,
      //           fontWeight: FontWeight.bold,
      //           // fontStyle: FontStyle.normal,
      //           fontSize: 4.w,
      //         ),
      //       ),
      //     ),
      //   ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TopContainer(),
            const SizedBox(
              height: 2,
            ),
            const Flexible(
              child: BottomContainer(),
            ),
          ],
        ),
      ),
      floatingActionButton: InkResponse(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewEntryPage(),
              ));
        },
        child: SizedBox(
          width: 110,
          height: 80,
          child: Card(
            color: kPrimaryColor,
            // shadowColor: Colors.black38,
            shape: CircleBorder(),
            child: Icon(
              Icons.add_circle_outline,
              color: kScaffoldColor,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(
            bottom: 1,
          ),
          child: Text(
            'Worry less. \nLive Healthier.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(
            bottom: 1,
          ),
          child: Text(
            'Welcome to Daily Dose',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        StreamBuilder<List<Medicine>>(
            stream: globalBloc.medicineList$,
            builder: (contxet, snapshot) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 1),
                child: Text(
                  !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            }),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Text(
    //     'No Medicine',
    //     textAlign: TextAlign.center,
    //     style: Theme.of(context).textTheme.displaySmall,
    //   ),
    // );

    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder(
      stream: globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No Medicine',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          );
        } else {
          // return GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //   ),
          //   itemCount: snapshot.data!.length,
          //   itemBuilder: (context, index) {
          //     return MedicineCard(medicine: snapshot.data![index]);
          //   },
          // );
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                  height: 20.h,
                  width: 14.h,
                  child: MedicineCard(medicine: snapshot.data![index]));
            },
          ); //
        }
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});
  final Medicine medicine;
  // for getting the current details of the saved items

  //first we need to get the medicine type iocn
  //make a function

  Hero makeIcon(double size) {
    if (medicine.medicineType == 'Syrup') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Image.asset(
          'assets/images/syrup.png',
          //color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Pill') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Image.asset(
          'assets/images/pills.png',
          //color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Syringe') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Image.asset(
          'assets/images/syringe.png',
          //color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Capsule') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Image.asset(
          'assets/images/capsule.png',
          //color: kOtherColor,
          height: 7.h,
        ),
      );
    }

    //incase of no medicine type
    return Hero(
      tag: medicine.medicineName! + medicine.medicineType!,
      child: Icon(
        Icons.error,
        color: kOtherColor,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: khomeitemColor,
      splashColor: Colors.grey,
      onTap: () {
        //go to detail activity
        // Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const MedicineDetails(),
        //       ));

        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AnimatedBuilder(
                  animation: animation,
                  builder: (context, Widget? child) {
                    return Opacity(
                      opacity: animation.value,
                      child: MedicineDetails(medicine),
                    );
                  });
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: khomeitemColor,
          borderRadius: BorderRadius.circular(2.h),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //const Spacer(),
            SizedBox(
              width: 2.h,
            ),

            //called hero
            makeIcon(7.h),
            //const Spacer(),
            SizedBox(
              width: 6.h,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: medicine.medicineName!,
                    child: Text(
                      medicine.medicineName!,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  //time stamp will be here after
                  Text(
                    medicine.interval == 1
                        ? "Every ${medicine.interval} hour"
                        : "Every ${medicine.interval} hour",
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
