import 'dart:math';
import 'package:flashcards/widgets/FlashCardWidget.dart';
import'package:flutter/material.dart';
import '../models/flashcard.dart';

class Practicescreen extends StatefulWidget {
  const Practicescreen({
    super.key, 
    required this.flashCardList, 
    required this.idList,
    }) : index = 0;

  const Practicescreen.fromIndex({
    super.key, 
    required this.flashCardList, 
    required this.idList,
    required this.index,
    });

  final List<FlashCard> flashCardList;
  final List<String> idList;
  final int index;
  @override
  State<Practicescreen> createState() => _PracticescreenState();
}

class _PracticescreenState extends State<Practicescreen> with TickerProviderStateMixin{


  

  bool checkBoxValue = false;

  bool hasSwiped = false;
  late PageController controller;

  late AnimationController _animController;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  void initState(){
    super.initState();
    controller = PageController(initialPage: widget.index);
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(end:1.0, begin: 0.0).animate(_animController)
    ..addListener((){
      setState(() {
        
      });
    })..addStatusListener(
      (status){
        _status = status;
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: widget.flashCardList.length,
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) {
          setState(() {
            checkBoxValue = false;
            _animController.reset();
            hasSwiped = true;
          });
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                      ..setEntry(2, 1, 0.0015)
                      ..rotateY(pi * _animation.value),
                      child: _animation.value <= 0.5 ? 
                      FlashCardWidget(
                        isFlipped: false, 
                        wordName: widget.flashCardList[index].wordName,
                        wordCategory: widget.flashCardList[index].wordType, 
                        wordAnswer: widget.flashCardList[index].wordMeaning
                      ) :
                      Transform(
                        alignment: FractionalOffset.center,
                        transform: Matrix4.identity()
                        ..setEntry(2, 1, 0.0015)
                        ..rotateY(pi),
                        child: FlashCardWidget(
                          isFlipped: true, 
                          wordName: widget.flashCardList[index].wordName,
                          wordCategory: widget.flashCardList[index].wordType, 
                          wordAnswer: widget.flashCardList[index].wordMeaning
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if(_animation.value > 0.5)
              FadeTransition(
                opacity: _animController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    CheckboxListTile(
                      title: const Text("Add flashcard to revision list?"),
                      subtitle: const Text(
                        "If certain flashcard needs constant revision, consider adding it to the revision list. ",
    
                      ),
                      value: widget.idList.contains(widget.flashCardList[index].id), 
                      onChanged: (value) {
                        if(value!){
                          setState(() {
                            widget.idList.add(widget.flashCardList[index].id);
                          });
                        }
                        else{
                          setState(() {
                            widget.idList.remove(widget.flashCardList[index].id);
                          });
                        }
                    },),
                  ],
                ),
              ),
              //const SizedBox(height: 30,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if(!hasSwiped)
                    const Icon(Icons.swipe_right),
                  ],
               ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin : const EdgeInsets.all(16),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: (){
                        setState(() {
                          if(_status == AnimationStatus.dismissed){
                            _animController.forward();
                          }
                          else{
                            _animController.reverse();
                          }
                        });
                      }, child: const Text("Flip Card")),
                    ),
                  )
                ],
              )  
            ],
          );
      },)
    );
  }
}