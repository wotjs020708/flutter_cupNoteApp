import 'package:flutter/material.dart';
import 'package:flutter_coffee_note/database/cafe_databaseConfig.dart';
import 'package:flutter_coffee_note/model/cafe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cafeNameController = TextEditingController();
  final TextEditingController _beanNameController = TextEditingController();
  final TextEditingController _brewingController = TextEditingController();
  final TextEditingController _hotIceController = TextEditingController();
  final TextEditingController _processingController = TextEditingController();
  final TextEditingController _cupNoteController = TextEditingController();

  final CafeDatabaseSrvice _databaseSrvice = CafeDatabaseSrvice();

  Future<List<Cafe>> _cafeList = CafeDatabaseSrvice()
      .databaseConfig()
      .then((_) => CafeDatabaseSrvice().selecteCafes());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "COFFEE CUPNOTE",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.help_center_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => showHelpDialog(),
                );
              },
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: _cafeList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No data exitsts."),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return cafeBox(
                    snapshot.data![index].id!,
                    snapshot.data![index].cafeName,
                    snapshot.data![index].beenName,
                    snapshot.data![index].brewing,
                    snapshot.data![index].hotIce,
                    snapshot.data![index].processing,
                    snapshot.data![index].cupNote,
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("erro occured."),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          // 카페 추가 버튼
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => addCafeDialog(),
            );
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget cafeBox(int id, String cafeName, String beenName, String brewing,
      String hotIce, String processing, String cupNote) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.brown.shade300,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              offset: const Offset(10, 10),
              color: Colors.black.withOpacity(0.3),
            )
          ]),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "cafe : $cafeName",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text("beanName : $beenName",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(
            height: 30,
          ),
          Text("brewing : $brewing",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(
            height: 30,
          ),
          Text("Hot/Ice : $hotIce",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(
            height: 30,
          ),
          Text("Processing : $processing",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(
            height: 30,
          ),
          Text("Cup Note : $cupNote",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              updateButton(id),
              deleteButton(id),
            ],
          ),
        ],
      ),
    );
  }

  Widget updateButton(int id) {
    return ElevatedButton(
      onPressed: () {
        Future<Cafe> cafe = _databaseSrvice.selecteCafe(id);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => updateCafeDialog(cafe),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      child: const Icon(Icons.edit),
    );
  }

  Widget deleteButton(int id) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => deleteCafeDialog(id),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      child: const Icon(Icons.delete),
    );
  }

  Widget addCafeDialog() {
    _cafeNameController.text = "";
    _beanNameController.text = "";
    _brewingController.text = "";
    _cupNoteController.text = "";
    _hotIceController.text = "";
    _processingController.text = "";
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("카페 추가"),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _cafeNameController,
            decoration: const InputDecoration(hintText: "cafeName"),
          ),
          TextField(
            controller: _beanNameController,
            decoration: const InputDecoration(hintText: "beanName"),
          ),
          TextField(
            controller: _brewingController,
            decoration: const InputDecoration(hintText: "brewing"),
          ),
          TextField(
            controller: _hotIceController,
            decoration: const InputDecoration(hintText: "Hot/Ice"),
          ),
          TextField(
            controller: _processingController,
            decoration: const InputDecoration(hintText: "processing"),
          ),
          TextField(
            controller: _cupNoteController,
            decoration: const InputDecoration(hintText: "cupnote"),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              _databaseSrvice
                  .insertCafe(Cafe(
                cafeName: _cafeNameController.text,
                beenName: _beanNameController.text,
                brewing: _brewingController.text,
                hotIce: _hotIceController.text,
                processing: _processingController.text,
                cupNote: _cupNoteController.text,
              ))
                  .then((result) {
                if (result) {
                  Navigator.of(context).pop();
                  setState(() {
                    _cafeList = _databaseSrvice.selecteCafes();
                  });
                } else {
                  print("insert error");
                }
              });
            },
            child: const Text("생성"),
          )
        ],
      ),
    );
  }

  Widget updateCafeDialog(Future<Cafe> cafe) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("카페 수정"),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: FutureBuilder(
        future: cafe,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _cafeNameController.text = snapshot.data!.cafeName;
            _beanNameController.text = snapshot.data!.beenName;
            _brewingController.text = snapshot.data!.brewing;
            _cupNoteController.text = snapshot.data!.cupNote;
            _hotIceController.text = snapshot.data!.hotIce;
            _processingController.text = snapshot.data!.processing;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _cafeNameController,
                  decoration: const InputDecoration(hintText: "cafeName"),
                ),
                TextField(
                  controller: _beanNameController,
                  decoration: const InputDecoration(hintText: "beenName"),
                ),
                TextField(
                  controller: _brewingController,
                  decoration: const InputDecoration(hintText: "brewing"),
                ),
                TextField(
                  controller: _hotIceController,
                  decoration: const InputDecoration(hintText: "Hot/Ice"),
                ),
                TextField(
                  controller: _processingController,
                  decoration: const InputDecoration(hintText: "processing"),
                ),
                TextField(
                  controller: _cupNoteController,
                  decoration: const InputDecoration(hintText: "cupnote"),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    _databaseSrvice
                        .updateCafe(Cafe(
                      id: snapshot.data!.id,
                      cafeName: _cafeNameController.text,
                      beenName: _beanNameController.text,
                      brewing: _brewingController.text,
                      hotIce: _hotIceController.text,
                      processing: _processingController.text,
                      cupNote: _cupNoteController.text,
                    ))
                        .then((result) {
                      if (result) {
                        Navigator.of(context).pop();
                        setState(() {
                          _cafeList = _databaseSrvice.selecteCafes();
                        });
                      } else {
                        print("update error");
                      }
                    });
                  },
                  child: const Text("수정"),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error occurred"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
    );
  }

  Widget deleteCafeDialog(int id) {
    return AlertDialog(
      title: const Text("이 카페 삭제하시겠습니까?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _databaseSrvice.deleteCafe(id).then((result) {
                    if (result) {
                      Navigator.of(context).pop();
                      setState(() {
                        _cafeList = _databaseSrvice.selecteCafes();
                      });
                    } else {
                      print("delete error");
                    }
                  });
                },
                child: const Text("예"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("아니요"),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget showHelpDialog() {
    return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("도움말"),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("컵노트를 형식에 맞게 입력하세요"),
            SizedBox(
              height: 20,
            ),
            Text("삭제 : 삭제버튼 클릭"),
            Text("수정 : 수정버튼 클릭"),
            Text("추가 : 추가버튼 클릭"),
          ],
        ));
  }
}
