import 'dart:convert';
import 'package:flashcards/functions/route.dart';
import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/screens/mainmenu.dart';
import 'package:flashcards/screens/wordaddscreen.dart';
import 'package:flashcards/widgets/customSearchDelegate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardEditScreen extends StatefulWidget {
  const CardEditScreen({super.key});


  @override
  State<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends State<CardEditScreen> {

  List<FlashCard> flashCardList = [];
  List<String> idList = [];
  bool isLoading = false;
  List<String> groupList = ["All"];
  String selectedGroup = "All";
  Map<String, List<FlashCard>> groupMap = {};

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
        if(!groupMap.containsKey(newFlashCard.wordType)){
        groupMap[newFlashCard.wordType] = [newFlashCard];
         }
        else{
        groupMap[newFlashCard.wordType] = [...groupMap[newFlashCard.wordType]!,newFlashCard];
        }
        groupMap['All'] = [...groupMap['All']!, newFlashCard];
        if(!groupList.contains(newFlashCard.wordType)) groupList.add(newFlashCard.wordType);
        groupList.toSet().toList();
        isLoading = false;
      });
    }

  Future<void> removeItem(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    FlashCard reqFlashCard = groupMap[selectedGroup]![index];
    String id = groupMap[selectedGroup]![index].id;
    String removeWordType = '';
    flashCardList.removeWhere((element) {
      if(element.id==id){
        removeWordType = element.wordType;
        return true;
      }
      return false;
    },);
    if(groupMap[removeWordType] != null){
      groupMap[removeWordType]!.removeWhere((element) {
      return element.id == id;
    },);
    }
    
    groupMap['All']!.removeWhere((element) {
      return element.id == id;
    },);
    setState(() {
      if(groupMap[removeWordType] != null && groupMap[removeWordType]!.isEmpty){
      groupMap.remove(removeWordType);
      groupList.remove(removeWordType);
      selectedGroup = 'All';
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: "Undo",
          onPressed: () async {
                flashCardList.add(reqFlashCard);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String>? data = prefs.getStringList('flashCardList');
                Map newData = {
                  "wordName" : reqFlashCard.wordName,
                  "wordType" : reqFlashCard.wordType,
                  "wordMeaning" : reqFlashCard.wordMeaning,
                  "id" : reqFlashCard.id,
                };
                if(data!=null){
                  data.add(json.encode(newData));
                  prefs.setStringList('flashCardList', data);
                }
                setState((){
                  initializeList();
                });
            }
        ),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 3),
        content: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
           Text("Card Removed"),
          ],),
      ),
    );
    });
    

    List<String> dataList = pref.getStringList('flashCardList')!;
    for(final d in dataList){
      Map data = json.decode(d);
      if(data['id'] == id){
        dataList.remove(d);
        break;
      }
    }
    pref.setStringList('flashCardList', dataList);
    if(idList.contains(id)){
      idList.remove(id);
      pref.setStringList('troubleList', idList);
    }
  }

  void initializeList() async{

    flashCardList = [];
    idList = [];
    isLoading = false;
    groupList = ["All"];
    selectedGroup = "All";
    groupMap = {};

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
    groupMap['All'] = [];
    for(FlashCard f in flashCardList){
      if(!groupList.contains(f.wordType)){
        groupList = [...groupList, f.wordType];
        groupMap[f.wordType] = [f];
      }
      else{
        groupMap[f.wordType] = [...groupMap[f.wordType]!, f];
      }
      groupMap['All'] = [...groupMap['All']!, f];
    }

    setState(() {
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
    Widget displayWidget = 
    isLoading ? 
    const CircularProgressIndicator()
    : flashCardList.isNotEmpty ? 
    Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: (){
                    addItem();
                  }, 
                  icon: const Icon(Icons.add)),
              Expanded(
                child: ListView.builder(
                  itemCount: groupList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                      return  InkWell(
                        onTap: (){
                          setState(() {
                            selectedGroup = groupList[index];
                          });
                        },
                        child: Card(
                          color: selectedGroup == groupList[index] ? Colors.purple : Colors.white,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                const SizedBox(width: 8,),
                                Center(
                                  child: Text(
                                    groupList[index],
                                    style: TextStyle(
                                      color: selectedGroup == groupList[index] ? Colors.white : Colors.black
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8,),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: groupMap[selectedGroup]!.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(groupMap[selectedGroup]![index].id),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) async{
                  await removeItem(index);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20,50,20),
                  child: InkWell(
                    onTap: () async{
                      FlashCard reqFlashCard = groupMap[selectedGroup]![index];
                      int index2 = 0;
                      for(int i = 0; i<flashCardList.length; i++){
                        if(flashCardList[i].id == reqFlashCard.id){
                          index2 = i;
                          break;
                        }
                      }
                      List<String>? newData = await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WordAdditionScreen.editingMode(
                          enteredWordName: reqFlashCard.wordName,
                          enteredWordCategory: reqFlashCard.wordType, 
                          enteredAnswer: reqFlashCard.wordMeaning,
                          ),
                        ));
                      if(newData == null || newData == []){
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      flashCardList[index2].wordName = newData[0];
                      flashCardList[index2].wordType = newData[1];
                      flashCardList[index2].wordMeaning = newData[2];
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      List<String> Data = [];
                      for(int i = 0; i<flashCardList.length; i++){
                        Map newData = {
                          'wordName' : flashCardList[i].wordName,
                          'wordType' : flashCardList[i].wordType,
                          'wordMeaning' : flashCardList[i].wordMeaning,
                          'id' : flashCardList[i].id,
                        };
                        Data = [...Data, json.encode(newData)];
                      }
                      prefs.setStringList('flashCardList', Data);
                      setState(() {
                        initializeList();
                        isLoading = false;
                      });
                    },
                    child: Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                groupMap[selectedGroup]![index].wordName,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ) : 
    const Center(
      child: Text("No FlashCard in the inventory, try creating one"),
    );

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          border: Border.all(color: Colors.black),
        ),
        width: double.infinity,
        height: 50,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            IconButton(onPressed: (){
              Navigator.of(context).pushReplacement(createRoute(const StartingScreen(), 1)
            );
            }, icon: const Icon(
              Icons.home, 
              color: Colors.black,)),
            IconButton(
              onPressed: (){},
              icon: const Icon(
                Icons.edit,
                color: Colors.purple,
                fill: 0.5,
              )
            ),
          ],),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Edit your Flashcards",
          style: TextStyle(color: Colors.white)
        ),
        actions:  [
          IconButton(
            onPressed: (){
              showSearch(
                context: context, 
                delegate: CardSearchDelegate(
                  flashCardList: flashCardList,
                  resetFunction : initializeList,
              ));
            }, 
            icon: const Icon(Icons.search, color: Colors.white,)),
        ],
      ),
    body: displayWidget,
    );
  }
}