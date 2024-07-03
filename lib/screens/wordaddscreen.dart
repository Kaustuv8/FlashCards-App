import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WordAdditionScreen extends StatelessWidget {
  WordAdditionScreen({
    super.key,
    this.enteredAnswer = "",
    this.enteredWordCategory = "",
    this.enteredWordName = ""
  }); 

  WordAdditionScreen.editingMode({
    super.key, 
    required this.enteredWordName, 
    required this.enteredWordCategory, 
    required this.enteredAnswer}); 

  String enteredWordName;
  String enteredWordCategory;
  String enteredAnswer;

  final formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {


    void save(){
      bool isValid = formKey.currentState!.validate();
      if(isValid){
        formKey.currentState!.save();
        //print("${enteredWordName}      ${enteredWordCategory}      ${enteredAnswer}");
        Navigator.of(context).pop([enteredWordName, enteredWordCategory, enteredAnswer]);
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        save();
      } , child: const Icon(Icons.add),),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        
        title: Text("Create a new FlashCard",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: 
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.all(Radius.circular(8))
                      ),
                    margin: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Container(
                            margin: const EdgeInsets.fromLTRB(15, 2, 15, 0),
                            child: TextFormField(
                              initialValue: enteredWordName,
                              minLines: 1,
                              maxLines: 2,
                              onSaved: (newValue) {
                                enteredWordName = newValue!.trim();
                              },
                              validator: (value) {
                                if(value==null || value.isEmpty) return "Enter a valid word or question";
                                return null;
                              },
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              
                              ),
                              decoration: InputDecoration(
                                
                                border: InputBorder.none,
                                hintText: "Enter a word or a question",
                                hintStyle: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            margin: const EdgeInsets.fromLTRB(50, 2, 50, 0),
                            child: TextFormField(
                              initialValue: enteredWordCategory,
                              minLines: 1,
                              maxLines: 2,
                              onSaved: (newValue) {
                                enteredWordCategory = newValue!.trim();
                              },
                              validator: (value) {
                                if(value==null || value.isEmpty) return "Enter a valid category";
                                return null;
                              },
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,                              
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter a category",
                                hintStyle: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Container(
                            height: 100,
                            margin: const EdgeInsets.fromLTRB(15, 2, 15, 0),
                            child: Center(
                              child: TextFormField(
                                initialValue: enteredAnswer,
                                minLines: 1,
                                maxLines: 10,
                                onSaved: (newValue) {
                                  enteredAnswer = newValue!.trim();
                                },
                                validator: (value) {
                                  if(value==null || value.isEmpty) return "Enter a valid answer";
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                              
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter an answer",
                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
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
}