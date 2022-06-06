import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'book.freezed.dart';
part 'book.g.dart';


@freezed
class Book with _$Book {
  const factory Book({
    final int? id,
    final String? title,
    final int? year,
  }) = _Book;

  factory Book.fromJson(Map<String,Object?> data) => _$BookFromJson(data);
}