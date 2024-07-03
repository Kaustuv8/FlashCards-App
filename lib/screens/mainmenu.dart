import 'dart:convert';
import 'package:flashcards/functions/route.dart';
import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/screens/cardeditscreen.dart';
import 'package:flashcards/screens/practicescreen.dart';
import 'package:flashcards/screens/wordaddscreen.dart';
import 'package:flashcards/widgets/groupselectionwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {

  List<FlashCard> flashCardList = [];
  bool isLoading = false;
  //List<FlashCard> troubleFlashCard = [];
  List<String> idList = [];


  

  void initializeList() async{
    flashCardList = [];
    isLoading = false;
    idList = [];
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    //pref.setStringList('flashCardList', []);
    //pref.setStringList('troubleList',[]);
    final List? data = pref.getStringList("flashCardList");
    final List? troubleData = pref.getStringList("troubleList");
    if(data==null || data.isEmpty){
      setState(() {
        flashCardList = [];
      });
    }
    else{
      for(String d in data){
        Map newData = jsonDecode(d);
        flashCardList = [
          ...flashCardList,
          FlashCard.withId(
            wordName: newData['wordName'], 
            wordType: newData['wordType'], 
            wordMeaning: newData['wordMeaning'],
            id : newData['id'],),
        ];
      }
    }
    if(troubleData==null || troubleData.isEmpty){
      setState(() {
        idList = [];
      });
    }
    else{
      for(String d in troubleData){
        //Map newData = jsonDecode(d);
        idList = [
          ...idList,
          d,
        ];
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> addTroubleItem() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //List<String>? reqList = prefs.getStringList("troubleList");
    //if(reqList == null || reqList.isEmpty){
      prefs.setStringList("troubleList", idList);
    //}
    //else{
    //  for(final data in troubleFlashCard){
    //    Map newData = {
    //      "wordName" : data.wordName,
    //      "wordType" : data.wordType,
    //      "wordMeaning" : data.wordMeaning,
    //    };
    //    prefs.setStringList("troubleList", [...reqList, json.encode(newData)]);
    //  }
    //}
    setState(() {
      isLoading = false;
    });
  }

  void addItem() async {
    List? newFlashCardData = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WordAdditionScreen(),
        )
      );
      setState(() {
        isLoading = true;
      });
      if(newFlashCardData == null){
        setState(() {
          isLoading = false;
        });
        return;
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      FlashCard newFlashCard = FlashCard(
        wordName: newFlashCardData[0], 
        wordType: newFlashCardData[1], 
        wordMeaning: newFlashCardData[2]);
      final getData = pref.getStringList("flashCardList");
      Map data = {
        "wordName" : newFlashCardData[0],
        "wordType" : newFlashCardData[1],
        "wordMeaning" : newFlashCardData[2],
        "id" : newFlashCard.id,
      };
      if(getData==null || getData.isEmpty) {
        await pref.setStringList('flashCardList', [json.encode(data)]);
      }
      else{ 
        await pref.setStringList('flashCardList', [...getData,json.encode(data)]);
      }
      
      setState(() {
        flashCardList = [...flashCardList, newFlashCard];
        isLoading = false;
      });
    }

  @override
  void initState(){
    super.initState();
    setState(() {
      initializeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget upperCardWidget = const Text("No Flashcards in need of revision");
    if(idList.isNotEmpty){
      upperCardWidget = Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 3),
              child: Text("Cards in need of revision : ${idList.length}")),
          ),
          ListView.builder(
          itemCount: idList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            List<FlashCard> displayFlashCards = flashCardList.where(
              (element)=>idList.contains(element.id),).toList();
            return Center(
              child: InkWell(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return Practicescreen.fromIndex(
                      flashCardList: displayFlashCards, 
                      idList: idList, 
                      index: index);
                      },
                    )
                  );
                  setState(() {
                    idList = idList.toSet().toList();
                    }
                  );
                  addTroubleItem();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 290,
                  margin: const EdgeInsets.fromLTRB(10,50,20,10),
                  height: double.infinity,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              displayFlashCards[index].wordName,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Type : ${displayFlashCards[index].wordType}",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),),
                  )),
              ),
              );
            },
          ),
        ],
      );
    }
    Widget displayWidget = Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)), 
              ),
              child: Stack(
                children:[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8), 
                        topRight: Radius.circular(8)),
                    ),
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text("Current number of FlashCards : ${flashCardList.length}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                    height: 250,
                    margin: const EdgeInsets.fromLTRB(20,50,20,20),
                    child: Center(
                      child: upperCardWidget,
                      ),
                    ),
                  ),
                ], 
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  height: 100,
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 8,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if(flashCardList.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            showCloseIcon: true,
                            content: Text("No Flashcard in inventory, start by creating one!"))
                        );
                        return;
                      }
                      List<FlashCard> passedFlashCardList = flashCardList;
                      List<String> groupList = ["Cancel", "All"];
                      for(FlashCard f in flashCardList){
                        if(!groupList.contains(f.wordType)) groupList.add(f.wordType);
                      }
                      List<bool>? checkMarkList;
                      if(groupList.length > 3){
                        checkMarkList = await Navigator.of(context).push(ModalBottomSheetRoute(
                          isScrollControlled: false,
                          builder: (context) {
                            return GroupSelectionWidget(
                              groupList: groupList,
                            );
                          },
                          )
                        );
                      }
                      else {groupList.remove("Cancel");}
                      if(groupList[0] == "Cancel") return;
                      
                      if(checkMarkList!=null && checkMarkList[0] == false){
                        for(int i = 1; i<checkMarkList.length;i++){
                          if(!checkMarkList[i]){
                            passedFlashCardList.removeWhere((element) {
                              return element.wordType == groupList[i];
                            },);
                          }
                        }
                      }
                      if(passedFlashCardList.isEmpty){
                        setState(() {
                          initializeList();
                        });
                        return;
                      }
                      passedFlashCardList.shuffle();
                      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return Practicescreen(
                          flashCardList: passedFlashCardList,
                          idList : idList,
                          );
                      },));
                      setState(() {
                        idList = idList.toSet().toList();
                      });
                      await addTroubleItem();
                      setState(() {
                          initializeList();
                        });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Start Practising",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  margin: const EdgeInsets.only(
                    left: 8,
                    right: 20,
                  ),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      addItem();
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Add a new FlashCard",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    
    if(isLoading){
      displayWidget = const Center(child: CircularProgressIndicator(),);
    }

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          border: Border.all(color: Colors.black),
        //  borderRadius: const BorderRadius.only(
        //    topLeft: Radius.circular(8),
        //    topRight: Radius.circular(8),
        //  ),
        ),
        width: double.infinity,
        height: 50,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            IconButton(onPressed: (){

            }, icon: const Icon(
              Icons.home, 
              color: Colors.purple,)),
            IconButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(createRoute(const CardEditScreen(), 0)
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
                fill: 0.5,
              )
            ),
          ],),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Flash Card Learning",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(child: displayWidget),
    );
  }
}