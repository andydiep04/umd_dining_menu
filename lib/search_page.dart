import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'controller.dart';
import 'package:http/http.dart'as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;


class MenuPage extends StatelessWidget {
  DataController dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: SafeArea(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: dataController.name.length,
          itemBuilder: (BuildContext context,int index)
          {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dataController.name[index].toString().trim(),style: const TextStyle(fontSize: 15,color: Colors.green,fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Expanded(child: Text(dataController.date[index].toString().trim().replaceAll('Dining Hall', ''),style: const TextStyle(fontSize: 12,color: Colors.blueGrey),textAlign: TextAlign.center)),
                        Expanded(child: Text(dataController.location[index].toString().trim().replaceAll('Dining Hall', ''),style: const TextStyle(fontSize: 12,color: Colors.blueGrey),textAlign: TextAlign.center)),
                        Expanded(child: Text(dataController.type[index].toString().trim().replaceAll('Dining Hall', ''),style: const TextStyle(fontSize: 12,color: Colors.blueGrey),textAlign: TextAlign.center)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    ),
  );
}

class MenuSearch extends SearchDelegate<String> {

  //DataController dataController = Get.put(DataController());

  final foods = [
    'Today\'s Menu',
    'Chicken',
    'Beef',
    'Steak',
    'Pork',
    'Meatballs',
    'Pasta',
    'Noodle',
    'Salad',
    'Fish',
    'Salmon',
    'Tuna',
  ];

  final recentFoods = [
    'Today\'s Menu',
    'Chicken',
    'Beef',
    'Steak',
    'Pork',
    'Meatballs',
    'Pasta',
    'Noodle',
    'Salad',
    'Fish',
    'Salmon',
    'Tuna',
  ];

  // Retrieve the menu based on the keyword search
  Future<DataController> getData(String keyword) async{
    DataController dataController = Get.put(DataController());
    // Reset all values in controller
    Get.reset();

    //var keyword = query;
    //var keyword = 'ALL';
    var location = 'ALL';
    var date = 'ALL';

    if (keyword.contains('Today')) {
      // Define search fields
      keyword = 'ALL';
      var currentDate = DateTime.now();
      var day = currentDate.day.toString();
      var month = currentDate.month.toString();
      var year = currentDate.year.toString();
      date = month + '%2F' + day + '%2F' + year;
      location = 'ALL';

    } else {
      date = 'ALL';
      location = 'ALL';
    }

    //var url = 'https://nutrition.umd.edu/search.aspx?Action=SEARCH&strCurKeywords=ALL&strCurSearchLocs=ALL&strCurSearchDays=ALL';
    var url = 'https://nutrition.umd.edu/search.aspx?Action=SEARCH&strCurKeywords=' + keyword + '&strCurSearchLocs=' + location + '&strCurSearchDays=' + date;

    print("Searching for: $keyword");
    var response = await http.Client().get(Uri.parse(url));
    dom.Document document = parser.parse(response.body);

    for(int k = 0; k<=0;k++) {
      var element = document.querySelectorAll('table>tbody')[k];
      var data = element.querySelectorAll('tr');
      //var uri = element.querySelectorAll('href');
      for (int i = 1; i < data.length; i++) {
        // gather the 4 cells for each row in the table
        dataController.addName(data[i].children[0].text.toString().trim());
        dataController.addUri(data[i].children[0].innerHtml.tr);
        dataController.addDate(data[i].children[1].text.toString().trim());
        dataController.addLocation(data[i].children[2].text.toString().trim());
        dataController.addType(data[i].children[3].text.toString().trim());
      }
    }
    return dataController;
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          //close(context, null);
          close(context, '');
        } else {
          query = '';
          showSuggestions(context);
        }
      },
    )
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) => FutureBuilder<DataController>(
    future: getData(query),
    //future: getData('Meatballs'),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator(color: Colors.green,));
        default:
          if (snapshot.hasError) {
            return Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Text(
                'No match found or something went wrong!',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            );
          } else {
            //print(snapshot.data!);
            return buildResultSuccess(snapshot.data!);
          }
      }
    },
  );

  Widget buildResultSuccess(DataController dataController) => Container(
    color: Colors.transparent,
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: dataController.name.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(dataController.name[index].toString().trim(),
                    style: const TextStyle(fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),),
                ),
                //Text(dataController.uri[index].toString().trim(),
                //  style: const TextStyle(fontSize: 10,
                //      color: Colors.blueAccent,)
                //  ,),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(dataController.date[index]
                          .toString().trim()
                          .replaceAll('Dining Hall', 'abc'),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.blueGrey),
                          textAlign: TextAlign.center)),
                      Expanded(child: Text(dataController.location[index]
                          .toString().trim()
                          .replaceAll('Dining Hall', 'abc'),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.blueGrey),
                          textAlign: TextAlign.center)),
                      Expanded(child: Text(dataController.type[index]
                          .toString().trim()
                          .replaceAll('Dining Hall', 'abc'),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.blueGrey),
                          textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    ),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? recentFoods
        : foods.where((food) {
      final foodLower = food.toLowerCase();
      final queryLower = query.toLowerCase();

      return foodLower.startsWith(queryLower);
    }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
      final suggestion = suggestions[index];
      final queryText = suggestion.substring(0, query.length);
      final remainingText = suggestion.substring(query.length);

      return ListTile(
        onTap: () {
          query = suggestion;

          // 1. Show Results
          showResults(context);

          // 2. Close Search & Return Result
          // close(context, suggestion);

          // 3. Navigate to Result Page
          //  Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => ResultPage(suggestion),
          //   ),
          // );
        },
        //leading: Icon(Icons.location_city),
        // title: Text(suggestion),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: queryText,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: remainingText,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}