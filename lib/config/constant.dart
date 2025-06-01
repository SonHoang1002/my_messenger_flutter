const String BASE_API = "http://127.0.0.1:8080/";

const int TIMEOUT_DURATION = 30; // second

const String BASE_WSS = 'ws://127.0.0.1:8080/ws-chat';

const String BASE_ASSET_PATH = "assets/";

const String BASE_REACTION_ASSET_PATH = BASE_ASSET_PATH+"reactions/";

const String PATH_ANGRY_GIF = BASE_REACTION_ASSET_PATH+"angry.gif";
const String PATH_HAHA_GIF = BASE_REACTION_ASSET_PATH+"haha.gif";
const String PATH_LIKE_GIF = BASE_REACTION_ASSET_PATH+"like.gif";
const String PATH_LOVE_GIF = BASE_REACTION_ASSET_PATH+"love.gif";
const String PATH_WOW_GIF = BASE_REACTION_ASSET_PATH+"wow.gif";
const String PATH_YAY_GIF = BASE_REACTION_ASSET_PATH+"yay.gif";
const String PATH_SAD_GIF = BASE_REACTION_ASSET_PATH+"sad.gif";

const String PATH_ANGRY_IMAGE = BASE_REACTION_ASSET_PATH+"angry.png";
const String PATH_HAHA_IMAGE = BASE_REACTION_ASSET_PATH+"haha.png";
const String PATH_LIKE_IMAGE = BASE_REACTION_ASSET_PATH+"like.png";
const String PATH_LOVE_IMAGE = BASE_REACTION_ASSET_PATH+"love.png";
const String PATH_WOW_IMAGE = BASE_REACTION_ASSET_PATH+"wow.png";
const String PATH_YAY_IMAGE = BASE_REACTION_ASSET_PATH+"yay.png";
const String PATH_SAD_IMAGE = BASE_REACTION_ASSET_PATH+"sad.png";

class MessageActionType {
  static final CREATE_NEW_MESSAGE = "create_new_message";
  static final UPDATE_TEXT = "update_text";
  static final UPDATE_IMAGE = "update_image";
  static final UPDATE_SEEN = "update_seen";
  static final UPDATE_REACTION = "update_reaction";
  static final DELETE_MESSAGE = "delete_message";
}

class MessageDeleteRole{
    static String DELETE_WITH_ALL = "delete_with_all";
    static String DELETE_WITH_ME = "delete_with_me";
}