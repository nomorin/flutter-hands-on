import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_hands_on/pages/product_detail.dart';
import 'package:flutter_hands_on/components/product_card.dart';
import 'package:flutter_hands_on/stores/product_list_store.dart';
import 'package:provider/provider.dart';
// main()はFlutterアプリケーションのエントリポイントです
// main()の中で、runAppにルートとなるウィジェットを格納して呼ぶ必要があります

// 元記事
//https://tech.pepabo.com/2020/05/27/flutter-hands-on/
void main() async {
  await DotEnv().load('.env');
//  runApp(MyApp());
  runApp(MultiProvider(

    providers: [
      ChangeNotifierProvider(
          create: (context) => ProductListStore(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}
//class MyApp extends StatefulWidget {
//  MyApp({Key key}) : super(key: key);
//
//  @override
//  _MyAppState createState() => _MyAppState();
//}

//  @override
//  Widget build(BuildContext context) {
//
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(),
//    );
//  }
//}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // addPostFrameCallbackは、initStateが呼ばれた後に一度のみ実行されるコールバック
    // ウィジェットの描画を行う際、最初の一度のみ実行したい処理を記述する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<ProductListStore>();

      if (store.products.isEmpty){
        store.fetchNextProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        ProductDetail.routeName: (context) => ProductDetail(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suzuri"),
      ),
      // body で表示したいウィジェットを別のメソッドに切り分ける
      body: _productList(context),
    );


//    return Scaffold(
//      appBar: AppBar(
//        title: const Text("SUZURI"),
//      ),
//      body: Center(
//        child: Text("Hello, SUZURI!"),
//      ),
//    );
  }

  // Wegetを返すメソッド
  // 引数にbuildcontextを渡す
  Widget _productList(BuildContext context){

    final store = context.watch<ProductListStore>();
    final products = store.products;

    if(products.isEmpty){
     return Container(

        // 子要素作成
        child:
        GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // グリッド横方向の要素
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7

            ),
            itemCount: 6,

            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey,
                margin: EdgeInsets.all(16),
              );
            }),
     );
    } else {
//      return Center(child: Text("Products"));
      return Container(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
//              return Container(
//                margin: EdgeInsets.all(16),
//                child: Image.network(products[index].sampleImageUrl),
//              );
            }
        ),
      );
    }
  }
}
