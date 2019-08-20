import 'Helpers.dart';
import 'package:cli/BibleParser.dart';

class Bible {

  var biblePath;
  var module;
  var data;

  Bible(String bible) {
    this.biblePath = FileIOHelper().getDataPath("bible", bible);
    this.module = bible;
  }

  Future loadData() async {
    this.data = await JsonHelper().getJsonObject(this.biblePath);
  }

  Future search(String searchString) async {
    if (this.data == null) await this.loadData();

    var searchResults = this.data.where((i) => (i["vText"].contains(RegExp(searchString)) as bool)).toList();
    String versesFound = "";
    for (var found in searchResults) {
      var b = found["bNo"];
      var c = found["cNo"];
      var v = found["vNo"];
      var bcvRef = BibleParser("ENG").bcvToVerseReference(b, c, v);
      var text = found["vText"];
      versesFound += "$bcvRef $text\n\n";
    }
    print("$searchString is found in ${searchResults.length} verse(s).\n\n");
    print(versesFound);
  }

}