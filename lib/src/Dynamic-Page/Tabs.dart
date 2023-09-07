import 'package:flutter/material.dart';
// import 'package:sliding_sheet/sliding_sheet.dart';

import '../constants.dart';
import 'drawer.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TabBar(
                            unselectedLabelColor: Colors.white,
                            labelColor: Colors.black,
                            indicatorColor: Colors.white,
                            indicatorWeight: 2,
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            controller: tabController,
                            tabs: [
                              Tab(
                                text: 'Tab 1',
                              ),
                              Tab(
                                text: 'Tab 1',
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  controller: tabController,
                  children: [
                    DrawerPage(title: "Drawer"),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                                // enableDrag: false,
                                // isDismissible: false,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                )),
                                context: context,
                                builder: (context) => buildSheet());
                          },
                          child: Text("Draggable Modal Bottom Sheet")),
                      // child: ElevatedButton(
                      //     onPressed: () {},
                      //     child: Text("Draggable Modal Bottom Sheet")),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildSheet() {
    return makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.7,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: EdgeInsets.all(16.0),
          child: ListView(
            controller: controller,
            children: [
              Image.asset(
                bgImage,
                // height: height * 0.50,
                // width: width,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Home Delivery",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "We Will Deliver The Professionals To Your Selected Address"),
            ],
          ),
        ),
      ),
    );
  }

  // Future showSheet() => showSlidingBottomSheet(context,
  //     builder: (context) => SlidingSheetDialog(
  //           snapSpec: SnapSpec(
  //             snappings: [0.4, 0.7],
  //           ),
  //           builder: buildSheetNew,
  //         ));

  // Widget buildSheetNew(context, state) => Material(
  //       child: Column(
  //         children: [],
  //       ),
  //     );
}
