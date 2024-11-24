import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';

// import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:flutter/material.dart';

import 'package:flutter_study/time_timer/provider/on_timer_listener.dart';
import 'package:flutter_study/time_timer/provider/app_config.dart';
import 'package:flutter_study/time_timer/provider/time_config.dart';
import 'package:flutter_study/time_timer/viewModels/timer_view_model.dart';
import 'package:flutter_study/time_timer/repository/timer_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';

import 'package:flutter_study/time_timer/widgets/bottom_bar.dart';
import 'package:flutter_study/time_timer/widgets/pizza_type.dart';
import 'package:flutter_study/time_timer/widgets/battery_type.dart';

import 'package:flutter_study/time_timer/list_drawer.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_study/time_timer/screen/setting_screen.dart'
    as setting_screen;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  // @override
  // Widget build(BuildContext context) {
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => TimeConfigListener()),
  //       ChangeNotifierProvider(create: (context) => AppConfigListener()),
  //       ChangeNotifierProvider(create: (context) => OnTimerListener()),
  //       ChangeNotifierProvider(
  //           create: (context) => TimerViewModel(TimerRepository(prefs))),
  //       // shared preferences 컨트롤
  //     ],
  //     child: MaterialApp(
  //       title: 'My Time Timer',
  //         theme: ThemeData(
  //           // expansionTileTheme: ExpansionTileThemeData(
  //           //   // tilePadding : EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
  //           //   // childrenPadding : EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
  //           //   backgroundColor: Colors.grey[200],
  //           //   textColor: Colors.blue,
  //           // ),
  //         ),
  //       home:  MyTimeTimer()),
  //   );
  // }

  // 크몽
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streaming Audio App',
      home: StreamingWithOpus(),
      // home: FileDownloadAndDecode(),
    );
  }
// 크몽
}
class StreamingWithOpus extends StatefulWidget {
  @override
  _StreamingWithOpusState createState() => _StreamingWithOpusState();
}

class _StreamingWithOpusState extends State<StreamingWithOpus> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // 오디오 플레이어
  final List<int> _buffer = []; // 데이터 버퍼
  bool _isPlaying = false; // 현재 재생 상태
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _startStreaming();
  }

  Future<String> getTempFilePath(String fileName) async {
    final tempDir = await getTemporaryDirectory(); // 임시 디렉토리 가져오기
    return '${tempDir.path}/$fileName';
  }

  /// 실시간 스트리밍 데이터를 수신하고 버퍼링
  Future<void> _startStreaming() async {
    final url = 'https://api.jigpu.com:2126/stream_opus_audio_full'; // 스트리밍 URL
    // final request = http.Request('GET', Uri.parse(url));
    // final response = await http.Client().send(request);

    // if (response.statusCode == 206) {
    //   _streamSubscription = response.stream.listen(
    //         (chunk) async {
    //       _buffer.addAll(chunk); // 받은 데이터를 버퍼에 추가
    //       if (!_isPlaying && _buffer.length > 100000) { // 버퍼가 충분히 쌓이면
    //         _isPlaying = true;
    //         await _convertAndPlayBuffer();
    //       }
    //     },
    //     onDone: () {
    //       print("스트리밍 완료");
    //     },
    //     onError: (error) {
    //       print("오류 발생: $error");
    //     },
    //     cancelOnError: true,
    //   );
    // } else {
    //   print('스트리밍 시작 실패: ${response.statusCode}');
    // }

    /// 변수 설정
    final response = await http.head(Uri.parse(url));  /// 파일 크기 확인을 위한 HEAD 요청
    // final contentLength = int.parse(response.headers['content-length'] ?? '0'); /// 파일의 전체 크기
    int chunkSize = 1048576;  /// 청크 크기 100KB (필요에 맞게 조절)
    int startByte = 0;
    int endByte = chunkSize - 1;
    bool tf = true;
    int seq = 0;

    // print(contentLength);
    /// 빈 opus 파일을 생성
    // final opusSink = opusFile.openWrite(mode: FileMode.append);
    // final wavSink = wavFile.openWrite(mode: FileMode.append);

    /// opus 파일의 데이터를 청크 단위로 다운로드
    while (startByte < 3000000) {
    // while (seq < 3) {
      /// 각 청크의 Range 헤더 설정 (몇 바이트씩 받을지 설정)
      final request = http.Request("GET", Uri.parse(url))
        ..headers.addAll({"Range": "bytes=$startByte-$endByte"});
      // print("range: ${startByte} ~ ${endByte} bytes");
      final response = await request.send();


      // final response = await http.get(Uri.parse(url))..headers.addAll({"Range": "bytes=$startByte-$endByte"});
      // print("range: ${startByte} ~ ${endByte} bytes");
      // response.bodyBytes;
      // print(response.statusCode);
      /// 상태 코드가 206 (청크 다운로드 성공)일 경우
      if (response.statusCode == 206) {
        // print('청크');
        //   _buffer.addAll(await response.stream.toBytes());
        // await _convertAndPlayBuffer();
        // // final chunkData = await response.stream.toBytes();
        // // print("Received chunk length: ${chunkData.length} bytes");
        //
        print("range: ${startByte} ~ ${endByte} bytes");
        //
        _streamSubscription = response.stream.listen(

              (chunk)  {
                if (chunk.length > 2) {
                _buffer.addAll(chunk);
                // print("유효한 청크 추가됨: ${chunk.length} bytes");
              } else {
                  _buffer.addAll(chunk);
                // final data = String.fromCharCodes(chunk);
                // print('2바이트 데이터의 내용: $data');
              }
            // _buffer.addAll(chunk); // 받은 데이터를 버퍼에 추가
            // if (!_isPlaying && _buffer.length > 1048575) { // 버퍼가 충분히 쌓이면
            //   _isPlaying = true;
            //    _convertAndPlayBuffer(seq);
            // }
          },
          onDone: ()  {
                print(seq);
            if (!_isPlaying && _buffer.length > 1048575) { // 버퍼가 충분히 쌓이면
              _isPlaying = true;
              _convertAndPlayBuffer(seq);
            }
            print("스트리밍 완료");
          },
          onError: (error) {
            print("오류 발생: $error");
          },
          cancelOnError: true,
        );

      } else if (response.statusCode == 200) {
        // startByte = 9999000000;
        // // final tempDir = await getTemporaryDirectory();
        // // final downloadedFile = io.File('${tempDir.path}/downloaded.opus');
        // // await downloadedFile.writeAsBytes(response.bodyBytes);
        // // response.bodyBytes;
        // _buffer.addAll(response.bodyBytes);
        // await _convertAndPlayBuffer();
        // _streamSubscription = response.stream.listen(
        //       (chunk) async {
        //
        //     // _buffer.addAll(chunk); // 받은 데이터를 버퍼에 추가
        //     // if (!_isPlaying && _buffer.length > 1048575) { // 버퍼가 충분히 쌓이면
        //     //   _isPlaying = true;
        //     //   await _convertAndPlayBuffer();
        //     // }
        //         if (chunk.length > 2) {
        //           _buffer.addAll(chunk);
        //           print("유효한 청크 추가됨: ${chunk.length} bytes");
        //         } else {
        //           final data = String.fromCharCodes(chunk);
        //           print('2바이트 데이터의 내용: $data');
        //         }
        //   },
        //   onDone: () async {
        //     // 스트리밍이 완료되면 버퍼 데이터를 변환 및 재생
        //
        //     if (_buffer.isNotEmpty) {
        //       print('스트리밍 완료');
        //       await _convertAndPlayBuffer();
        //     } else {
        //       print("버퍼가 비어 있습니다. 재생할 데이터가 없습니다.");
        //     }
        //   },
        //   onError: (error) {
        //     print("오류 발생: $error");
        //   },
        //   cancelOnError: true,
        // );

        break;
      } else {
        print('다운로드 실패: ${response.statusCode}');
        break;
      }

      /// 청크가 끝나면 다음 범위로 설정
      startByte += chunkSize;
      endByte += chunkSize;
      seq ++;
    }

    print("끝");
  }

  /// 버퍼 데이터를 Opus로 변환한 뒤 재생
  Future<void> _convertAndPlayBuffer(int seq) async {
    print("재생 : ${seq}");
    while (_buffer.isNotEmpty) {
      // print("재생");
      final inputData = Uint8List.fromList(_buffer); // 현재 버퍼 데이터
      _buffer.clear(); // 버퍼 초기화

      // 임시 파일 경로 설정/                                                           /
      // final inputPath = '/path/to/temp_input.raw'; // 원시 입력 데이터
      // final outputPath = '/path/to/output.opus'; // 변환된 Opus 데이터
      //

      // 임시 파일 경로 설정
      // final inputPath = await getTempFilePath('temp_input.raw'); // 임시 입력 파일 경로
      // final outputPath = await getTempFilePath('output.opus'); // 변환된 Opus 파일 경로

      // final inputPath = '${tempDir.path}/downloaded.opus';
      // final outputPath = io.File('${tempDir.path}/decoded.wav');

      // await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(inputPath)));
      // await _audioPlayer.play();

      // Future<void> checkIfOpus(String filePath) async {
      //   final command = '-i "$filePath"';
      //   await FFmpegKit.executeAsync(command, (session) async {
      //     final logs = await session.getAllLogsAsString();
      //     print(logs);
      //     if (logs!.contains('Audio: opus')) {
      //       print('파일이 Opus 형식입니다.');
      //     } else {
      //       print('파일이 Opus 형식이 아닙니다.');
      //     }
      //   });
      // }

      final tempDir = await getTemporaryDirectory();
      final downloadedFile = io.File('${tempDir.path}/downloaded.opus');
      await downloadedFile.writeAsBytes(inputData);

      final outputFile = io.File('${tempDir.path}/decoded.wav');

      // Opus 변환 명령 실행
      // final command = '-f s16le -ar 44100 -ac 2 -i "$inputPath" -c:a libopus "$outputPath"';
      final command = '-i "${downloadedFile.path}" -ar 48000 -ac 2 -y "${outputFile.path}"';
      // final command = '-i ${inputPath} -ar 48000 -ac 2 -y ${outputPath}';
      // await FFmpegKit.executeAsync('-i ${opusFile.path} -ar 48000 -ac 2 -y ${wavFile.path}');
      await FFmpegKit.executeAsync(command, (session) async {
        final returnCode = await session.getReturnCode();
        // prepareFilePaths();
        // checkIfOpus(outputPath);
        // print(session.getLogs());
        if (returnCode!.isValueSuccess()) {
          // print('Opus 변환 성공: $outputFile.path');
          // 변환된 Opus 파일을 재생
          await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(outputFile.path)));
          // await _audioPlayer.setFilePath(outputFile.path);
          await _audioPlayer.play();
        } else {
          // print('Opus 변환 실패: ${await session.getAllLogsAsString()}');
          // print('Opus 변환 실패: ${await session.getAllLogsAsString()}');
        }
      });
    }
    _isPlaying = false; // 변환 및 재생 완료 후 초기화
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Streaming + Opus Conversion')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _audioPlayer.pause();
          },
          child: Text('정지'),
        ),
      ),
    );
  }
}


class FileDownloadAndDecode extends StatefulWidget {
  @override
  _FileDownloadAndDecodeState createState() => _FileDownloadAndDecodeState();
}

class _FileDownloadAndDecodeState extends State<FileDownloadAndDecode> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _status = "대기 중...";

  Future<void> downloadAndDecode(String url) async {
    setState(() {
      _status = "다운로드 중...";
    });

    try {
      // 1. 파일 다운로드
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final downloadedFile = io.File('${tempDir.path}/downloaded.opus');
        await downloadedFile.writeAsBytes(response.bodyBytes);
        print("파일 다운로드 완료: ${downloadedFile.path}");

        setState(() {
          _status = "파일 다운로드 완료, 디코딩 중...";
        });

        // 2. Opus 디코딩
        final outputFile = io.File('${tempDir.path}/decoded.wav');
        final command =
            '-i "${downloadedFile.path}" -ar 48000 -ac 2 -y "${outputFile
            .path}"';
        await FFmpegKit.executeAsync(command, (session) async {
          final returnCode = await session.getReturnCode();
          final logs = await session.getLogsAsString();
          if (returnCode!.isValueSuccess()) {
            print("디코딩 성공: ${outputFile.path}");
            setState(() {
              _status = "디코딩 완료, 재생 중...";
            });

            // 3. 오디오 재생
            await _audioPlayer.setFilePath(outputFile.path);
            await _audioPlayer.play();
          } else {
            print("디코딩 실패: $logs");
            setState(() {
              _status = "디코딩 실패";
            });
          }
        });
      } else {
        print("파일 다운로드 실패: ${response.statusCode}");
        setState(() {
          _status = "파일 다운로드 실패";
        });
      }
    } catch (e) {
      print("오류 발생: $e");
      setState(() {
        _status = "오류 발생";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('URL 파일 다운로드 및 디코딩'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: '파일 URL 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (urlController.text.isNotEmpty) {
                  downloadAndDecode(
                      "https://api.jigpu.com:2126/stream_opus_audio_full");
                }
              },
              child: Text('다운로드 및 재생'),
            ),
            SizedBox(height: 16),
            Text(_status ?? "대기 중"),
          ],
        ),
      ),
    );
  }
}

// 크몽

class ResponsiveApp {
  static MediaQueryData? _mediaQueryData;

  MediaQueryData? get mq => _mediaQueryData;

  static void setMq(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }
}

class MyTimeTimer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyTimeTimerState();
}

class _MyTimeTimerState extends State<MyTimeTimer>
    with AutomaticKeepAliveClientMixin {
// GlobalKey 생성
  // final GlobalKey<_PizzaTypeState> pizzaTypeKey = GlobalKey<_PizzaTypeState>();
  late MediaQueryData mediaQueryData;
  late Size mediaSize;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 초기화
    context.read<TimerViewModel>().loadPreset();
    //
    // mediaQueryData = MediaQuery.of(context);
    // mediaSize = mediaQueryData.size;
    print('### 메인 위젯 빌드 ###');
    late Size mainSize = MediaQuery.sizeOf(context);
    print(mainSize);

    Offset clickPoint = Offset(150, -150);

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   // jdi 찾아보기
    //   context.read<AppConfigListener>().setMediaQuery = MediaQuery.of(context);

    //   double painterSize = context.read<AppConfigListener>().painterSize;
    // });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: Colors.green,
        title: Text('My Time Timer'),
        centerTitle: true,
        toolbarHeight: mainSize.height / 10,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => setting_screen.SettingScreen()),
              );
            },
            icon: Icon(Icons.settings),
            color: Colors.grey,
          )
        ],
      ),
      drawer: ListDrawer(), // 보조 화면
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: mainSize.height * (6 / 10),
                child: Center(
                  child:
                      // child:Text(''),
                      // GestureDetector(
                      //   onPanUpdate: (point) {
                      //     utils.showOverlayText(context);
                      //     Offset clickPoint = point.localPosition;
                      //     int angleToMin =
                      //         utils.angleToMin(clickPoint, Size(350, 350));
                      //     context.read<TimeConfigListener>().setSetupTime =
                      //         angleToMin;
                      //   },
                      //   child: Stack(children: [
                      //     PizzaTypeBase(size: Size(350, 350)),
                      //     PizzaType(
                      //       size: Size(350, 350),
                      //       isOnTimer: false,
                      //       setupTime: context.read<TimeConfigListener>().setupTime,
                      //     ),
                      //   ]),
                      // ),
                      GestureDetector(
                    onPanUpdate: (point) {
                      // utils.showOverlayText(context);

                      clickPoint = point.localPosition;
                      context.read<TimeConfigListener>().setClickPoint =
                          clickPoint;

                      int angleToMin =
                          utils.angleToMin(clickPoint, Size(350, 350));
                      context.read<TimeConfigListener>().setSetupTime =
                          angleToMin;
                    },
                    child: Stack(children: [
                      // BatteryType(clickPoint: clickPoint)
                      BatteryTypeBase(
                          size: Size(mainSize.width, mainSize.height)),
                      BatteryType(
                          size: Size(mainSize.width, mainSize.height),
                          isOnTimer: false,
                          setupTime:
                              context.read<TimeConfigListener>().setupTime,
                          clickPoint:
                              context.read<TimeConfigListener>().clickPoint),
                    ]),
                  ),
                )),
            SizedBox(
              height: mainSize.height * (2.0 / 10),
              child: ButtomBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
