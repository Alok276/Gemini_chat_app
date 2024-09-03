import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_chat_app/bloc/chat_bloc.dart';
import 'package:gemini_chat_app/models/chat_message_model.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    chatBloc.close(); // Close the bloc when the widget is disposed
    controller
        .dispose(); // Dispose of the controller when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => chatBloc,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              // Scroll to bottom when new messages are added
              if (state is ChatSuccessState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
              }
            },
            builder: (context, state) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              if (state is ChatSuccessState) {
                List<ChatMessageModel> messages = state.messages;

                return Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/universe.jpg"),
                          fit: BoxFit.cover),
                    ),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            08, 48, 08, keyboardHeight + 16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Title of the app
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Universe Pod",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.image_search,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ],
                              ),

                              // Chat view of the app
                              Expanded(
                                  child: ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 12, left: 08, right: 08),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.grey.withOpacity(0.7)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          messages[index].role == "user"
                                              ? "User"
                                              : "Universe Pod",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  messages[index].role == "user"
                                                      ? Colors.amber
                                                      : Colors.deepPurple),
                                        ),
                                        const SizedBox(
                                          height: 06,
                                        ),
                                        Text(
                                          messages[index].parts.first.text,
                                          style: const TextStyle(
                                              height: 1.2,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                              if (chatBloc.generating)
                                Column(
                                  children: [
                                    SizedBox(
                                        height: 150,
                                        width: 150,
                                        child:
                                            Lottie.asset('assets/loader.json')),
                                    const SizedBox(width: 10),
                                    const Text("Loading..."),
                                    const SizedBox(width: 20),
                                  ],
                                ),

                              // Chat box
                              Row(children: [
                                Expanded(
                                  child: TextField(
                                      controller:
                                          controller, // Attach the controller here
                                      cursorColor: Colors.black87,
                                      minLines: 1,
                                      maxLines: 10,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: const InputDecoration(
                                          hintText: "Ask something....",
                                          filled: true,
                                          fillColor: Colors.grey,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24)),
                                              borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.white)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24)),
                                              borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.white)))),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (controller.text.isNotEmpty) {
                                        String text = controller.text;
                                        controller.clear();
                                        chatBloc.add(
                                            ChatGenerateNewTextMessageEvent(
                                                inputMessage: text));
                                      }
                                    },
                                    child: const CircleAvatar(
                                        radius: 26,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 26,
                                            child: Icon(
                                              Icons.send,
                                              size: 28,
                                              color: Colors.white,
                                            ))))
                              ])
                            ])));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
