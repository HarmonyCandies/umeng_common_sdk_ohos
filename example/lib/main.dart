import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    UmengCommonSdk.initCommon('5e3f96f3cb23d2a070000048', '5e3f96f3cb23d2a070000048', 'Umeng');
    UmengCommonSdk.setPageCollectionModeManual();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await UmengCommonSdk.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Running on: $_platformVersion'),
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  TextButton(
                      // color: Colors.blue,
                      // highlightColor: Colors.blue[700],
                      // colorBrightness: Brightness.dark,
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                      foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                      padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onEvent(bool, {name:jack, age:18, male:true})"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onEvent('bool', {'name':'jack', 'age':18, 'male':true});
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onEvent(float, {name:jack, age:18, degree:1.6})"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onEvent('float', {'name':'jack', 'age':18, 'degree':1.6});
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onEvent(long, {name:jack, age:18, mobile:13910012345})"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onEvent('long', {'name':'jack', 'age':18, 'mobile':8613910012345});
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onEvent(array, {name:jack, age:18, children:[tom, jerry]})"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onEvent('array', {'name':'jack', 'age':18, 'male':true, 'mobile':13910012345, 'degree':1.6, 'children':['tom', 'jerry'], 'work':{'2000':'TC', '2005':'BAIDU', '2010':'ALI'}});
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onEvent(map, {name:jack, age:18, work:{2000:TC, 2005:BAIDU, 2010:ALI}})"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onEvent('map', {'name':'jack', 'age':18, 'work':{'2000':'TC', '2005':'BAIDU', '2010':'ALI'}});
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onEvent(null, {name:jack, age:18, like:null })"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onEvent('null', {'name':'jack', 'age':18, 'like':null});
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onEvent(map_array, {name:jack, age:18, work:{2000:TC, 2005:BAIDU, 2010:ALI}, children:[tom, jerry]})"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onEvent('map_array', {'name':'jack', 'age':18, 'children':['tom', 'jerry'],'work':{'2000':'TC', '2005':'BAIDU', '2010':'ALI'}});
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onProfileSignIn(jack)"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onProfileSignIn('jack');
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onProfileSignOff()"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onProfileSignOff();
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onPageStart(homeView)"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onPageStart('homeView');
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("onPageEnd(homeView)"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.onPageEnd('homeView');
                      }
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                      ),
                      child: Text("reportError(lost space)"),
                      // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        UmengCommonSdk.reportError('lost space');
                      }
                  )
                ]
            ),
          ),
          bottomNavigationBar:BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 1,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance), label: '主页'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.contacts), label: '列表'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_music), label: '个人')
            ],
          )
      ),
    );
  }
}
