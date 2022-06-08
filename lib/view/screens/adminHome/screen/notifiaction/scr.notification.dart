import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:getwidget/getwidget.dart';
import 'package:my_hospital_app/controller/firebaseController/services.firestore.dart';
import 'package:my_hospital_app/controller/services/service.my_service.dart';
import 'package:my_hospital_app/controller/utils/util.custom_statusbar.dart';
import 'package:my_hospital_app/controller/utils/util.custom_text.dart';
import 'package:my_hospital_app/model/consts/keywords.dart';
import 'package:my_hospital_app/view/screens/adminHome/screen/notifiaction/widget/noti_item.dart';

class MyNotificationScreen extends StatefulWidget {
  @override
  _MyNotificationScreenState createState() => _MyNotificationScreenState();
}

class _MyNotificationScreenState extends State<MyNotificationScreen> {
  double height = 160;
  var _chatScrollController;
  int noticeNum = 10; // at first it will load only 10
  // int a = 2; // 'loadMoreMsgs' will added by 'a' if we load more msgs in listview.

  @override
  void initState() {
    super.initState();
    /* print(ConstPrintColor.printYellow +
        "Notification initState() running.." +
        ConstPrintColor.endColor); */
    CustomStatusBar.mGetPrimaryStatusBar();

    _chatScrollController = ScrollController()
      ..addListener(() {
        if (_chatScrollController.position.atEdge) {
          if (_chatScrollController.position.pixels == 0)
            print('ListView scrolled to top');
          else {
            setState(() {
              noticeNum = noticeNum + 10;
            });
          }
        }
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("\x1b[32m Build: Screens/notifications.dart \x1b[0m");

    return WillPopScope(
      onWillPop: () async {
        // if (_showDialog)
        Navigator.pop(context);
        // Navigator.of(context).pushReplacement(newRoute)
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: CustomText(
          text: "Notifications",
          fontWeight: FontWeight.w400,
          fontsize: 22,
        )),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(ConstKeys.adminCollRef)
                .doc('gEmAMDRZYXtkJOklftDk')
                .collection(ConstKeys.notifications)
                .orderBy('dateTime', descending: true)
                .limit(noticeNum)
                .snapshots(),
            builder:
                (BuildContext bcontext, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return GFShimmer(child: _mEmptyBlock());
              }
              final myData = snapshot.requireData;

              return ListView.builder(
                controller: _chatScrollController,
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: myData.size,
                itemBuilder: (bcontext, index) {
                  // double h_ratio = selectedDateList.length < 2 ? 0.7 : 0.5;
                 

                  // print(myData.docs[index]['doctUid']);

                  return /* Container(); */
                      AdminNotiItem(
                          name: myData.docs[index]['doctUid'],
                          appointmentId: "appointmentId",
                          gender: "gender",
                          age: "age",
                          mobile: "mobile",
                          appointementDate: "appointementDate",
                          appointmentTime: "appointmentTime",
                          appointmentType: "appointmentType",
                          appointmentStatus: "appointmentStatus")
                      /* NotificationModel(
                    avatarurl: avatarurl,
                    desc: desc,
                    title: title,
                    userid: userid,
                    noticeid: noticeid,
                    noticeimgurl: noticeimgurl,
                    subtitle: "subtitle",
                    status: status,
                  ) */
                      ;
                },
              );
            }),
      ),
    );
  }

  Widget _mEmptyBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 46,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 8,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 8,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 46,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 8,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 8,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _mUpdateStatus(String id) {
    ServicesFirestore.collRefNotification
        .doc(id)
        .update({ConstKeys.status: "read"});
  }
}
