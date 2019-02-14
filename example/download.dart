import 'dart:io';
import 'package:dio/dio.dart';

// In this example we download a image and listen the downloading progress.
main() async {
  var dio = new Dio();

  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.idleTimeout = new Duration(seconds: 0);
  };

  // This is big file(about 200M)
  // var url = "http://download.dcloud.net.cn/HBuilder.9.0.2.macosx_64.dmg";

  var url = "https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/book.jpg";
  await download1(dio, url, "./example/book1.jpg");
  await download2(dio, url, "./example/book2.jpg");
}

Future download1(Dio dio, String url, String savePath) async {
  try {
    await dio.download(
      url,
      savePath,
      onReceiveProgress: showDownloadProgress,
    );
  } catch (e) {
    print(e);
  }
}

Future download2(Dio dio, String url, String savePath) async {
  try {
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(responseType: ResponseType.bytes),
    );
    File file = new File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    raf.close();
  } catch (e) {
    print(e);
  }
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}
