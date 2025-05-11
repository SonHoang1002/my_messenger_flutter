import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_messenger_app_flu/models/main_model.dart';
import 'package:my_messenger_app_flu/pages/chat_room_page.dart';
import 'package:my_messenger_app_flu/services/auth_service.dart';
import 'package:my_messenger_app_flu/services/home_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserChatEntity userChatData;
  late List<RoomEntity> roomsData = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      userChatData = await HomeService().getUserChat();
      roomsData = await HomeService().getRooms(userChatData.userChatId);
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi khi tải dữ liệu: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigation to create new room
          // Navigator.pushNamed(context, '/create-room');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Xin chào ${userChatData.userName}!',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: roomsData.isNotEmpty
                ? ListView.builder(
                    itemCount: roomsData.length,
                    itemBuilder: (context, index) {
                      RoomEntity room = roomsData[index];
                      return _buildRoomItem(room);
                    },
                  )
                : const Center(
                    child: Text('Không có phòng nào. Hãy tạo phòng mới!'),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomItem(RoomEntity room) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text("${room.roomId} ${room.roomName}"),
        subtitle: Text(
          room.lastMessage != null
              ? (room.lastMessage?.text) ?? 'Chưa có tin nhắn'
              : 'Chưa có tin nhắn',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          room.lastMessage != null
              ? _formatDateTime(room.lastMessage?.timestamp)
              : '',
          style: const TextStyle(fontSize: 12),
        ),
        onTap: () {
          Clipboard.setData(ClipboardData(text: room.roomId));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatRoomPage(
                    roomId: room.roomId, userId: userChatData.userChatId);
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(int? timestamp) {
    if (timestamp == null) return '';
    DateTime? dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // if (dateTime != null) {
    return TimeOfDay.fromDateTime(dateTime).format(context);
    // } else {
    //   return "--";
    // }
  }
}
