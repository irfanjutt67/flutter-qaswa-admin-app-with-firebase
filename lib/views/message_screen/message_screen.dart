import 'package:cloud_firestore/cloud_firestore.dart';
//
import '../../const/const.dart';
import '../../services/store_services.dart';
import 'chat_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: "My Messages".text.color(darkGrey).make(),
      ),
      body: StreamBuilder(
          stream: StoreServices.getAllmessage(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(red),
                ),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No message yet!".text.make(),
              );
            } else {
              var data = snapshot.data!.docs;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext contex, int index) {
                          return ListTile(
                            onTap: () {
                              Get.to(
                                () => const ChatScreen(),
                                arguments: [
                                  data[index]['sender_name'],
                                  data[index]['fromId']
                                ],
                              );
                            },
                            leading: const CircleAvatar(
                              backgroundColor: red,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: "${data[index]['sender_name']}"
                                .text
                                .color(darkGrey)
                                .make(),
                            subtitle: "${data[index]['last_msg']}".text.make(),
                          );
                        }),
                  ),
                ],
              );
            }
          }),
    );
  }
}
