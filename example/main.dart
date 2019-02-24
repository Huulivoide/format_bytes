import 'dart:io';

import 'package:format_bytes/format_bytes.dart';

class PathAndSize {
  final String path;
  final int size;

  PathAndSize(this.path, this.size);
}

void processDirectory(Directory dir) {
  var statStream = dir.list(recursive: true).where((entry) {
    return entry is File;
  }).asyncMap((entry) async {
    return PathAndSize(entry.path, (await entry.stat()).size);
  }).asBroadcastStream();

  var totalSize = statStream.fold(0, (total, entry) {
    return total + entry.size;
  });

  statStream.listen((entry) {
    print('${entry.path} ${format(entry.size)}');
  }).onDone(() async {
    print('Total size: ${format(await totalSize)}');
  });
}

main(List<String> args) {
  Directory root = Directory(args.isNotEmpty ? args.first : '.');
  processDirectory(root);
}
