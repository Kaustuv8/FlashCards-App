import'package:flutter/material.dart';

class FlashCardWidget extends StatelessWidget {
  const FlashCardWidget({super.key, 
    required this.isFlipped, 
    required this.wordName, 
    required this.wordCategory, 
    required this.wordAnswer});

  final bool isFlipped;
  final String wordName;
  final String wordCategory;
  final String wordAnswer;


  @override
  Widget build(BuildContext context) {

    Widget displayWidget = Container(
      margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Center(child: Text(
        wordName,
        textAlign: TextAlign.center, 
        style: Theme.of(context).textTheme.displaySmall,)));
    if(isFlipped) {
      displayWidget = Container(
        margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        child: Column(
          children: [
            Text(
              wordName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30,),
            Text(
              "Type : $wordCategory",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,),
            const SizedBox(height: 30,),
            Text(wordAnswer, style: Theme.of(context).textTheme.bodyLarge,),
          ],
        ));
    }

    return Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Container(
                  height: 400,
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
                    child: Center(
                      child: SingleChildScrollView(
                        child: displayWidget,
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