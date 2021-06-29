import 'package:flutter/material.dart';
import 'package:flutter_hands_on/models/product.dart';
import 'package:flutter_hands_on/requests/product_request.dart';

import 'package:http/http.dart' as http;

class ProductListStore extends ChangeNotifier{
  // 商品のリスト
  List<Product> _products = [];
  // 変更不可にしたいのでgetterを準備
  List<Product> get products => _products;


  // リクエスト中に再リクエストしないようにする
  bool _isFetching = false;
  bool get isFetching => _isFetching;

  // Storeに変更を要求する
  fetchNextProducts() async {
    if (_isFetching) {
      return;
    }

    _isFetching = true;

    final request = ProductRequest(
      client: http.Client(),
      offset: _products.length,
    );

    // request.fetchはList<Product>を返すFutureオブジェクトを返す
    final products = await request.fetch().catchError((e){
      _isFetching = false;
    });

    _products.addAll(products);
    _isFetching = false;

    // 追加できたら、このストアを購読しているウィジェットに通知を行う

    notifyListeners();
  }
}
