import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_care/constants.dart';
import 'package:med_care/global_bloc.dart';
import 'package:med_care/models/errors.dart';
import 'package:med_care/pages/home_page.dart';
import 'package:med_care/pages/new_entry/new_entry_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../common/convert_time.dart';
import '../../models/medicine.dart';
import '../../models/medicine_type.dart';
import '../success_screen/success_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;




//import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  FlutterLocalNotificationsPlugin  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NewEntryBloc _newEntryBloc = NewEntryBloc();
   

   



  void initstate() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    _newEntryBloc =  NewEntryBloc();
     _scaffoldKey = GlobalKey<ScaffoldState>();
     initializeNotifications();
    initializeErrorListen();
     
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
              backgroundColor:kAppBarColor,
              // shadowColor: Colors.lightBlue,
              elevation: 5,
              title: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 50),
                  child: Text(
                    'Add New',
                    style: GoogleFonts.mulish(
                      color: kAppBarTextColor,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.normal,
                      fontSize: 4.w,
                    ),
                  ),
                ),
              ),
            ),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(top: 2.h,bottom: 0.0,right: 2.h,left: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PanelTitle(
                  title: 'Medicine Name',
                  isRequired: true,
                ),
                TextFormField(
                  maxLength: 12,
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: kOtherColor,
                      ),
                ),
                const PanelTitle(
                  title: 'Dosage',
                  isRequired: true,
                ),
                TextFormField(
                  maxLength: 12,
                  controller: dosageController,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: kOtherColor,
                      ),
                ),
                const SizedBox(
                  height: 2,
                ),
                const PanelTitle(title: 'Medicnine Type', isRequired: false),
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: StreamBuilder<MedicineType>(
                    //new Entry Block
                     stream: _newEntryBloc.selectedMedicineType,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MedicineTypeColumn(
                              medicineType: MedicineType.Syrup,
                              name: 'Syrup',
                              iconValue: 'assets/images/syrup.png',
                              isSelected: snapshot.data == MedicineType.Syrup
                                  ? true
                                  : false),
                          MedicineTypeColumn(
                              medicineType: MedicineType.Pill,
                              name: 'Pill',
                              iconValue: 'assets/images/pills.png',
                              isSelected: snapshot.data == MedicineType.Pill
                                  ? true
                                  : false),
                          MedicineTypeColumn(
                              medicineType: MedicineType.Syringe,
                              name: 'Syringe',
                              iconValue: 'assets/images/syringe.png',
                              isSelected: snapshot.data == MedicineType.Syringe
                                  ? true
                                  : false),
                          MedicineTypeColumn(
                              medicineType: MedicineType.Capsule,
                              name: 'Capsule',
                              iconValue: 'assets/images/capsule.png',
                              isSelected: snapshot.data == MedicineType.Capsule
                                  ? true
                                  : false),
                        ],
                      );
                    },
                  ),
                ),
                const PanelTitle(title: 'Interval Selection', isRequired: true),
                const IntervalSelection(),
                const PanelTitle(title:'Starting Time', isRequired: true),
                const SelectTime(),
                 SizedBox(
                  height: 2.h,
                ),
                 Padding(
                   padding: EdgeInsets.only(
                    left: 8.w,
                    right: 8.w,
              
                   ),
                   child: SizedBox(
                    height: 8.h,
                    width: 80.w,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: const StadiumBorder(),
                      ),
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: kScaffoldColor,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Medicine info validation
                        String? medicineName;
                        int? dosage;
                        //medicines Name
                        if(nameController.text == ""){
                          _newEntryBloc.submitError(EntryError.nameNull);
                          return;
                        }
                        if(nameController.text != ""){
                            medicineName = nameController.text;
                        }
                        //dosage
                         if(dosageController.text == ""){
                          dosage = 0;
                        }
                        if(dosageController.text != ""){
                            dosage = int.parse(dosageController.text);
                        }
        
                        for(var medicine in globalBloc.medicineList$!.value){
                          if(medicineName == medicine.medicineName){
                            _newEntryBloc.submitError(EntryError.nameDuplicate);
                            return;
                          }
                        }
        
                        if(_newEntryBloc.selectIntervals!.value == 0){
                          _newEntryBloc.submitError(EntryError.interval);
                          return;
                        }
        
                        if(_newEntryBloc.selectedTimeOfDay$!.value == 'None'){
                          _newEntryBloc.submitError(EntryError.startTime);
                          return;
                        }
        
                        String medicineType = _newEntryBloc
                        .selectedMedicineType!.value
                        .toString()
                        .substring(13);
        
                        int interval = _newEntryBloc.selectIntervals!.value;
                        String startTime =
                             _newEntryBloc.selectedTimeOfDay$!.value;
        
                        List<int> intIDs = makeIDs(
                            24 / _newEntryBloc.selectIntervals!.value
                        );
                        List<String> notificationIDs = intIDs.map((i) => i.toString()).toList();
        
                        Medicine newEntryMedicine = Medicine(
                          notificationIDs : notificationIDs,
                          medicineName : medicineName,
                          dosage : dosage,
                          medicineType : medicineType,
                          interval : interval,
                          startTime : startTime
                        );
        
        
        
                        //update medicine list via global bloc
                        globalBloc.updateMedicineList(newEntryMedicine);
        
                        //schedule notification
                        scheduleNotification(newEntryMedicine);
        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context)=>SuccessScreen())
                        );
        
        
        
                      },
                      ),
                             ),
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void initializeErrorListen(){
  _newEntryBloc.errorState$!.listen((EntryError error) { 
    switch(error){
      case EntryError.nameNull:
      //show snackbar
      displayError("Please enter the Medicine's name");
      break;

      case EntryError.nameDuplicate:
      //show snackbar
      displayError("Medicine name already exists");
      break;

      case EntryError.dosage:
      //show snackbar
      displayError("Please enter the dosage required");
      break;

      case EntryError.interval:
      //show snackbar
      displayError("Please select the reminder's interval");
      break;

      case EntryError.startTime:
      //show snackbar
      displayError("Please select the reminder's starting time");
      break;
      default:

    }
  });
}

  void displayError(String error){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: kOtherColor,
      content: Text(error),
    duration: const Duration(seconds: 3),
    ),
  );
}

  List<int> makeIDs(double n){
      var rng = Random();
      List<int> ids = [];
      for(int i=0;i<n;i++){
        ids.add(rng.nextInt(1000000000));
      }
      return ids;
  }

  initializeNotifications() async{
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/launch_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }
   
  Future onSelectNotification(String? payload) async{
    if(payload != null){
      debugPrint('notification payload: $payload');
    }

    await Navigator.push(context,MaterialPageRoute(builder: (context)=> const HomePage()));
  }

  Future<void> scheduleNotification(Medicine medicine) async{
    var hour = int.parse(medicine.startTime![0] +  medicine.startTime![1]);
    var ogValue = hour;
    var minute =  int.parse(medicine.startTime![2]+medicine.startTime![3]);

    var androidPlatformChannelSpecifics
          = const AndroidNotificationDetails('repeatDailyAtTime channel id', 'repeatDailyAtTime name',
              importance: Importance.max,
              ledColor: kOtherColor,
              ledOffMs: 1000,
              ledOnMs: 1000,
              enableLights: true,
    );
    var iOSPlatformChannelSpecifics =
            const DarwinNotificationDetails();
    
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS:iOSPlatformChannelSpecifics,
    );


    for(int i=0;i<(24/medicine.interval!).floor();i++){
      if(hour + (medicine.interval! * i) > 23){
        hour = hour + (medicine.interval!*i)-24;
      }else {
        hour = hour + (medicine.interval! * 1);
      }

      // await flutterLocalNotificationsPlugin.showDailyAtTime(
      //   int.parse(medicine.notificationIDs![i]),
      //   'Reminder:${medicine.medicineName}',
      //   medicine.medicineType.toString() != MedicineType.None.toString() ?
      //   'It is time to take your ${medicine.medicineType!.toLowerCase()},according to schedule':
      //   'It is time to take your medicine, according to schedule',
      //    Time(hour,minute,0),
      //     platformChannelSpecifics);
      //     hour = ogValue;


      DateTime dt = DateTime.now(); //Or whatever DateTime you want
      final tzdatetime = tz.TZDateTime.from(dt, tz.local); //could be var instead of final
      await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(medicine.notificationIDs![i]),
        'Reminder: ${medicine.medicineName}',
        medicine.medicineType.toString() != MedicineType.None.toString()
            ? 'It is time to take your ${medicine.medicineType!.toLowerCase()}, according to schedule'
            : 'It is time to take your medicine, according to schedule',

        tz.TZDateTime.local(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel.id',
            'channel.name',
            // 'channel.description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
      hour = ogValue;

    }
  }

}

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
 TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
 bool _clicked = false;

Future<TimeOfDay> _selectTime() async{
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context,listen: false);

    final TimeOfDay? picked =
     await showTimePicker(context: context, initialTime: _time );

     if(picked != null && picked != _time){
      setState(() {
        _time = picked;
        _clicked = true;

        newEntryBloc.updateTime(convertTime(_time.hour.toString())+
        convertTime(_time.minute.toString()));
      });
     }
     return picked!;
}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Padding(
        padding:  EdgeInsets.only(top:2.h),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape: const StadiumBorder()
          ),
          onPressed: (){
            _selectTime();
        }, 
        child: Center(
          child: Text(
            _clicked == false
            ?
            "Select Time":
            "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: kScaffoldColor,
          ),),
        )
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key});

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _interval = [1,6, 8, 12, 24];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top:1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Remind me every',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: kTextColor,
            ),
          ),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            itemHeight: null,

            hint: _selected == 0
                ? Text(
                    'Select an Interval',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: kPrimaryColor,
                    ),
                  )
                : null,
                elevation: 4,
                value: _selected ==0 ?
                null : _selected,
            items: _interval.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value : value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: kSecondaryColor,
                    ),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                () {
                  _selected = newVal!;
                  newEntryBloc.updateInterval(newVal);
                },
              );
            },
          ),
          Text(_selected == 1 ? " hour" : " hours",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: kTextColor,
          ),
          ),
        ],
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {super.key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected});
  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        //selcct Medicine Type
        newEntryBloc.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.h),
              color: isSelected ? kOtherColor : Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 1,
                  bottom: 1,
                ),
                child: Image.asset(
                  iconValue,
                  height: 7.h,
                  //color: isSelected ? Colors.white : kOtherColor,
                  // Uncomment above line to match the icon color to theme
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: isSelected ? Colors.white : kOtherColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.title, required this.isRequired});
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextSpan(
              text: isRequired ? "*" : "",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: kPrimaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
