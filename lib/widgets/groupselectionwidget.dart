import 'package:flutter/material.dart';

class GroupSelectionWidget extends StatefulWidget {
  const GroupSelectionWidget({
    super.key,
    required this.groupList,
    });
  final List<String> groupList;

  @override
  State<GroupSelectionWidget> createState() => _GroupSelectionWidgetState();
}

class _GroupSelectionWidgetState extends State<GroupSelectionWidget> {
  List<bool> checkMarkList = [];

  @override
  void initState(){
    super.initState();
    setState(() {
      for(int i = 0; i<widget.groupList.length-1; i++){
        checkMarkList.add(false);
      }
      checkMarkList[0] = true;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Center(child: Text("Select categories you want to practice on"),),
        const SizedBox(height: 30),
        SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.groupList.sublist(1).length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: CheckboxListTile(
                          title: Text(widget.groupList.sublist(1)[index]),
                          value: checkMarkList[index], 
                          onChanged: (newvalue){
                            setState(() {
                              checkMarkList[index] = newvalue!;
                              if(widget.groupList.sublist(1)[index]!="All"){
                                if(newvalue) checkMarkList[0] = false;
                              }
                              if(widget.groupList.sublist(1)[index] == "All"){
                                if(newvalue == true){
                                  for(int i = 1; i<checkMarkList.length; i++){
                                    checkMarkList[i] = false;
                                  }
                                }
                              }
                            });
                          }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, 
            child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: (){
                widget.groupList.remove("Cancel");
                Navigator.of(context).pop(
                  checkMarkList
                );
              }, 
              child: const Text("Start")),
          ],
        ),
      ],
      ),
    );
  }
}