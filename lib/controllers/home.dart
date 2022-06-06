
import 'package:repo_bookstore/db/virtual_db.dart';
import 'package:repo_bookstore/repositories/book_repository.dart';

import '../models/book.dart';

class HomeController {
  final BookRepository _bookRepo = BookRepository(VirtualDB());

  Future<List<Book>> getAllBooks() {
    return _bookRepo.getAll();
  }

  Future<void> addBook(Book book) {
    return _bookRepo.insert(book);
  }

  Future<void> removeBook(int id) {
    return _bookRepo.delete(id);
  }
}