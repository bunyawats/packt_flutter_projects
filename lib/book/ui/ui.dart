import 'package:flutter/material.dart';
import '../data/book_helper.dart';
import '../data/book.dart';

class BookTable extends StatelessWidget {
  final List<Book> books;
  final bool isFavorite;

  BookTable(this.books, this.isFavorite);
  final helper = BookHelper();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(
        color: Colors.blueGrey,
      ),
      children: buildTableRow(context),
    );
  }

  List<TableRow> buildTableRow(BuildContext context) {
    return books.map((book) {
      return TableRow(children: [
        TableCell(
          child: TableText(book.title),
        ),
        TableCell(
          child: TableText(book.authors),
        ),
        TableCell(
          child: TableText(book.publisher),
        ),
        TableCell(
          child: IconButton(
            color: isFavorite ? Colors.red : Colors.amber,
            tooltip: isFavorite ? 'Remove form favorite' : 'Add to favorite',
            icon: Icon(Icons.star),
            onPressed: () {},
          ),
        ),
      ]);
    }).toList();
  }
}

class TableText extends StatelessWidget {
  final String text;
  TableText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
      ),
    );
  }
}
