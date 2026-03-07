# Chat Flow - Project Structure Guide

## Directory Overview

```
chat_flow/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── controllers/                       # State management (GetX)
│   │   ├── auth_controllers.dart          # Authentication logic
│   │   ├── login_screen_controller.dart   # Login form controller
│   │   ├── register_screen_controller.dart # Registration form controller
│   │   ├── splash_screen_controller.dart  # Splash screen logic
│   │   ├── main_screen_controller.dart    # Main tab navigation
│   │   ├── chat_screen_controller.dart    # Chat messaging logic
│   │   ├── find_friends_controller.dart   # User search & friend requests
│   │   ├── friends_controller.dart        # Friends list management
│   │   ├── notification_controller.dart   # Notification management
│   │   ├── profile_screen_controller.dart # Profile & settings logic
│   │   └── settings_screen_controller.dart # Security settings
│   │
│   ├── models/                            # Data models
│   │   ├── user_model.dart               # User profile data
│   │   ├── message_model.dart            # Chat message data
│   │   ├── friend_request_model.dart     # Friend request data
│   │   └── chat_model.dart               # Chat conversation data
│   │
│   ├── services/                          # Business logic & API
│   │   ├── auth_service.dart             # Firebase authentication
│   │   └── firestore_services.dart       # Firestore database operations
│   │
│   ├── views/                             # UI screens
│   │   ├── main_screen.dart              # Main navigation screen
│   │   ├── splash_screen.dart            # Loading/auth check screen
│   │   ├── chat_screen.dart              # Messaging UI
│   │   ├── chat_list_screen.dart         # List of active chats
│   │   ├── profile_screen.dart           # User profile view
│   │   ├── settings_screen.dart          # Account settings
│   │   ├── friends_screen.dart           # Friends list
│   │   ├── find_friends_screen.dart      # Friend search & requests
│   │   ├── notification_screen.dart      # Friend request notifications
│   │   ├── forgot_password_screen.dart   # Password recovery
│   │   └── auth/
│   │       ├── login_screen.dart         # Login form
│   │       └── register_screen.dart      # Registration form
│   │
│   ├── routes/                            # Navigation routing
│   │   ├── app_routes.dart               # Route constants
│   │   └── app_pages.dart                # Route definitions & bindings
│   │
│   ├── theme/                             # App theming
│   │   └── app_theme.dart                # Material design theme
│   │
│   ├── firebase_options.dart              # Firebase configuration
│   └── pubspec.yaml                       # Dependencies
│
├── firestore.rules                        # Firestore security rules
├── firebase.json                          # Firebase config
├── pubspec.yaml                           # Project manifest
└── README.md                              # Project documentation
```

## Key Data Flows

### Authentication Flow
1. User opens app → SplashScreen
2. SplashScreen checks Firebase auth state
3. If authenticated → MainScreen
4. If not → LoginScreen or RegisterScreen

### Messaging Flow
1. User goes to Friends tab
2. Clicks on friend → ChatScreen
3. ChatScreenController initializes chat with friend
4. Messages stream in real-time from Firestore
5. User can send/edit messages

### Friend Request Flow
1. User goes to Find Friends tab
2. Searches for users via FindFriendsScreen
3. Clicks "Add" → sends friend request
4. Recipient sees notification in Notifications page
5. Can accept or reject request
6. If accepted → chat becomes available

## Database Structure

### Users Collection
```
users/
  {userId}/
    - id: string
    - email: string
    - displayName: string
    - photoUrl: string
    - isOnline: boolean
    - lastSeen: timestamp
    - createdAt: timestamp
    
    friends/ (subcollection)
      {friendId}/
        - friendId: string
        - addedAt: timestamp
```

### Friend Requests Collection
```
friendRequests/
  {requestId}/
    - id: string
    - senderId: string
    - receiverId: string
    - status: 'pending' | 'accepted' | 'rejected'
    - timestamp: timestamp
    - senderName: string
    - senderEmail: string
    - senderPhotoUrl: string
```

### Chats Collection
```
chats/
  {chatId}/
    - id: string
    - user1Id: string
    - user2Id: string
    - user1Name: string
    - user2Name: string
    - user1PhotoUrl: string
    - user2PhotoUrl: string
    - lastMessage: string
    - lastMessageTime: timestamp
    - senderId: string
    
    messages/ (subcollection)
      {messageId}/
        - id: string
        - chatId: string
        - senderId: string
        - receiverId: string
        - content: string
        - timestamp: timestamp
        - isRead: boolean
        - editedAt: timestamp (optional)
```

## State Management (GetX)

### Controllers
- **AuthController**: Global auth state, handles login/register/logout
- **MainScreenController**: Bottom nav state and chat list stream
- **ChatScreenController**: Message handling and real-time updates
- **NotificationController**: Friend request notifications
- **ProfileScreenController**: User profile data and updates
- **SettingsScreenController**: Password and security settings

### Reactive Variables
- `RxBool`: Boolean values (isLoading, isOnline, etc.)
- `RxString`: String values (email, displayName, etc.)
- `RxList`: Collections (messages, friends, chats)
- `Rx<T>`: Any complex type (User, Message, etc.)

## Security Rules

All data is protected with Firestore security rules:
- Users can only read/write their own user profile
- Users can only see friend requests they're involved in
- Messages are only readable by sender and receiver
- Friend lists are private to each user
- Proper write permission checks prevent unauthorized data modification

## Getting Started

### Prerequisites
- Flutter SDK (3.10.4+)
- Firebase project configured
- Chrome browser

### Running the App
```bash
cd chat_flow
flutter pub get
flutter run -d chrome
```

### Building for Web Production
```bash
flutter build web --release
```

## Key Dependencies
- **get**: State management and navigation
- **firebase_core**: Firebase initialization
- **firebase_auth**: Firebase authentication
- **cloud_firestore**: Cloud database
- **uuid**: Unique ID generation
- **google_fonts**: Typography

## Future Enhancements
- Image sharing in messages
- Voice/video calling
- Group chat support
- Message search functionality
- User blocking/reporting
- Push notifications
- Dark mode support
- Internationalization (i18n)
