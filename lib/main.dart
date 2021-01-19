import 'package:flutter/material.dart';
import './fileReader.dart';

void main() => runApp(MaterialApp(
      home: Searcher(),
    ));

class Searcher extends StatefulWidget {
  @override
  _SearcherState createState() => _SearcherState();
}

class _SearcherState extends State<Searcher> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _wordList;
  String _searchText = "";
  List _searchResult = List();
  Future<List> _futureWords;

//input text listener
  _SearcherState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //get data from the file words.txt
    FileReader _instance = FileReader();
    _futureWords = _instance.loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Search field
          title: TextField(
            controller: _controller,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey[600])),
            cursorWidth: 3,
            onChanged: _searchOperation,
          ),
        ),
        body: FutureBuilder(
          future: _futureWords,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _wordList = snapshot.data ?? ''; // list of given words
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: _searchResult.length != 0 ||
                            _controller.text.isNotEmpty
                        ? _buildList(_searchResult) //if input text is NOT empty
                        : _buildList(_wordList), // if input text is empty
                  )
                ],
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  //list of search result or entire list
  Widget _buildList(listData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listData.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            listData[index],
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  //compare input text with list's elements
  void _searchOperation(_) {
    _searchResult.clear();
    for (int i = 0; i < _wordList.length; i++) {
      String data = _wordList[i];
      if (data.toLowerCase().startsWith(_searchText.toLowerCase())) {
        _searchResult.add(data);
      }
    }
  }
}
