import 'package:cloud_firestore/cloud_firestore.dart';
//
import '../../const/const.dart';
import '../../controller/chats_controller.dart';
import '../../services/store_services.dart';
import '../widgets/test_style.dart';
import 'components/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: darkGrey),
        ),
        title:
            boldText(text: controller.friendName, size: 16.0, color: darkGrey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(red),
                      ),
                    )
                  : Expanded(
                      child: StreamBuilder(
                          stream: StoreServices.getChatMessages(
                              controller.chatDocId.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(red),
                                ),
                              );
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: "Send a message"
                                    .text
                                    .color(darkGrey)
                                    .make(),
                              );
                            }
                            return ListView(
                              children: snapshot.data!.docs
                                  .mapIndexed((currentValue, index) {
                                var data = snapshot.data!.docs[index];
                                return Align(
                                    alignment: data['uid'] == currentUser!.uid
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: chatBubble(data));
                              }).toList(),
                            );
                          })),
            ),
            10.heightBox,
            Row(children: [
              Expanded(
                child: TextFormField(
                    controller: controller.msgController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: textfieldGrey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textfieldGrey)),
                      hintText: "Type your message...",
                    )),
              ),
              IconButton(
                  onPressed: () {
                    controller.sendMsg(controller.msgController.text);
                    controller.msgController.clear();
                  },
                  icon: const Icon(Icons.send, color: red)),
            ])
                .box
                .height(80)
                .padding(const EdgeInsets.all(12))
                .margin(const EdgeInsets.only(bottom: 8))
                .make(),
          ],
        ),
      ),
    );
  }
}
