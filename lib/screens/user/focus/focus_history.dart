import 'package:flutter/material.dart';
import 'package:lazyless/database/models/focus_model.dart';
import 'package:lazyless/database/sqflite.dart';

class FocusHistory extends StatefulWidget {
  const FocusHistory({super.key});

  @override
  State<FocusHistory> createState() => _FocusHistoryState();
}

class _FocusHistoryState extends State<FocusHistory> {



  late Future<List<FocusModel>> focus;
  final db = DatabaseHelper();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focus = db.readFocus();
    _refresh();
    db.initDB().whenComplete((){
      setState(() {
        focus = db.readFocus();
      });
    }
    );

  }


  //READ ALL NOTES
  Future<List<FocusModel>> readAllTimers() async {
    return await db.readFocus();
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      focus = readAllTimers();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus History'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<FocusModel>>(
        future: focus,
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('No focus history found.'));
          }else{
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index){
                final item = data[index];
                return Column(
                  children: [
                    
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), 
                        gradient:LinearGradient(
                          colors: [Color(0xFF98D8EF),Color(0xFF00CCDD)]
                        )
                      ),
                      child: ListTile(
                        title: Text('you stayed focus for ${item.focusTime}'),
                        subtitle: Text('you took ${item.breakNumber} breaks'),
                      ),
                    ),
                    SizedBox(height: screenHeight * .01)
                    
                  ],
                );
              }
            );
          }
        }
      )
    );
  }
}