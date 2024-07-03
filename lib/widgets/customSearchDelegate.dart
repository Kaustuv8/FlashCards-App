import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/screens/wordaddscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class CardSearchDelegate extends SearchDelegate{
  CardSearchDelegate({
    required this.flashCardList,
    required this.resetFunction,
  });

  final List<FlashCard> flashCardList;
  final void Function() resetFunction;

  void deleteItem(FlashCard result, List<FlashCard> matchQuery) async {
    flashCardList.remove(result);
    matchQuery.remove(result);
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
    resetFunction();
  }

  void restoreCard(FlashCard result, List<FlashCard> matchQuery) async{
    flashCardList.add(result);
    matchQuery.add(result);
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
  }


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<FlashCard> matchQuery = [];
    for (var f in flashCardList) {
      if (f.wordName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(f);
      }
    }
    return matchQuery.isEmpty ? const Center(child : Text("No result found")): 
    StatefulBuilder(
      builder:(context, StateSetter setState ){
        return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return Dismissible(
            key: Key(result.id),
            onDismissed: (direction){
              deleteItem(result, matchQuery);
              
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          duration:  Duration(seconds: 3),
          content:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             Text("Card Removed"),
            ],),
        ),);
            },
            child: ListTile(
              title: InkWell(
                onTap: () async{
                  List<String>? newData = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return WordAdditionScreen.editingMode(
                          enteredWordName: result.wordName,
                          enteredWordCategory: result.wordType,
                          enteredAnswer: result.wordMeaning,
                        );
                      },
                    ),
                  );
                  if(newData == null) return;
                  int index2 = flashCardList.indexOf(result);
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
                  resetFunction();
                  
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20,50,20),
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
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 100,
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            result.wordName,
                                            textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                       ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          );
        }
      );
    }
  );
       
      
      
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<FlashCard> matchQuery = [];
    for (var f in flashCardList) {
      if (f.wordName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(f);
      }
    }
    return matchQuery.isEmpty ? const Center(child : Text("No result found")): 
    ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: InkWell(
            onTap: () async{
              List<String>? newData = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return WordAdditionScreen.editingMode(
                      enteredWordName: result.wordName,
                      enteredWordCategory: result.wordType,
                      enteredAnswer: result.wordMeaning,
                    );
                  },
                ),
              );
              if(newData == null) return;
              int index2 = flashCardList.indexOf(result);
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
              resetFunction();
              if(!context.mounted) return;
              close(context, null);  
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 20,50,20),
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
                              child: SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        result.wordName,
                                        textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                   ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}