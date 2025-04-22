
# 📸 WallShare – Tạo ảnh bằng AI và chia sẻ mạng xã hội thời gian thực

WallShare là một ứng dụng di động được phát triển bằng Flutter, cho phép người dùng tạo ảnh từ mô tả (prompt) bằng công nghệ AI, sau đó chia sẻ ảnh cùng cộng đồng theo thời gian thực. Ứng dụng tích hợp Firebase cho backend và sử dụng dịch vụ AI như Stability AI để tạo ảnh.

---

## 🚀 Tính năng nổi bật

- ✅ Đăng nhập bằng tài khoản Google (Google Sign-In)
- ✅ Tạo ảnh AI từ mô tả ngôn ngữ (prompt)
- ✅ Đăng bài viết kèm mô tả, thể loại, tag
- ✅ Hiển thị bảng tin thời gian thực (realtime)
- ✅ Tương tác với ảnh: Like, bình luận
- ✅ Tìm kiếm ảnh theo tag, thể loại
- ✅ Quản lý hồ sơ người dùng, chỉnh sửa thông tin cá nhân

---

## 🛠️ Công nghệ sử dụng

- **Flutter** (Dart)
- **Firebase**: Authentication, Firestore, Storage
- **Stability AI**: Sinh ảnh từ prompt
- **Provider**: Quản lý trạng thái ứng dụng
- **Cloud Functions (optional)**: Tính năng nâng cao

---

## 📦 Cài đặt và chạy ứng dụng

### 1. Yêu cầu hệ thống

- Flutter SDK >= 3.x
- Dart >= 3.x
- Android Studio hoặc VSCode
- Tài khoản Firebase
- API Key của Stability AI (hoặc tương tự)

---

### 2. Clone project

```bash
git clone https://github.com/your-username/wallshare.git
cd wallshare
```

---

### 3. Cài đặt các package

```bash
flutter pub get
```

---

### 4. Cấu hình Firebase

- Tạo Firebase Project
- Kích hoạt **Authentication > Sign-in method > Google**
- Tạo file `google-services.json` và đặt tại thư mục `android/app/`
- (iOS: dùng `GoogleService-Info.plist` nếu triển khai)

---

### 5. Tạo file `.env`

Tạo file `.env` ở thư mục gốc chứa:

```
STABILITY_API_KEY=your_stability_api_key_here
```

---

### 6. Build và chạy ứng dụng

```bash
flutter run
```

---

## 📂 Cấu trúc thư mục chính

```
lib/
├── home_screen_widgets/
│   └── floating_searchbar.dart
│   └── home_appbar.dart
│   └── home_searchbar.dart
│   └── top_liked_carousel.dart
│   └── user_info_data.dart
├── models/
│   └── user_model.dart
│   └── wallpaper.dart
├── providers/
│   └── authentication_provider.dart
│   └── theme_provider.dart
│   └── wallpaper_provider.dart
├── screens/
│   └── create_wallpaper_screen.dart
│   └── edit_profile_screen.dart
│   └── home_screen.dart
│   └── profile_screen.dart
│   └── wallpaper_details_screen.dart
├── service/
│   └── wallpaper_service.dart
├── social/
│   └── comment_button.dart
│   └── comment_card.dart
│   └── comment_input_field.dart
│   └── comment_repository.dart
│   └── comment.dart
│   └── comments_sheet.dart
│   └── follow_repository.dart
│   └── like_button.dart
│   └── like_repository.dart
│   └── like.dart
├── themes/
│   └── app_themes.dart
├── utilities/
│   └── assets_manager.dart
│   └── my_image_cachemanager.dart
│   └── utilities.dart
├── widgets/
│   └── bottom_content.dart
│   └── controls_overlay.dart
│   └── creator_widget.dart
│   └── follow_button.dart
│   └── main_app_button.dart
│   └── promp_input_field.dart
│   └── prompt_widget.dart
│   └── sign_in_button.dart
│   └── social_details.dart
│   └── style_selector_button.dart
│   └── user_image_avatar.dart
│   └── user_info_section.dart
│   └── wallpaper_image.dart
│   └── wallpaper_info_overlay.dart
│   └── wallpaper_item.dart
│   └── wallpaper_placeholder.dart
│   └── wallpaper_preview.dart
│   └── wallpapers_grid.dart
├── constants.dart
├── firebase_options.dart
├── main.dart
```

---

## 🙌 Tác giả

- 👤 Tên sinh viên: [Nguyễn Đỗ Huy]
- 📘 Đề tài đồ án: *Ứng dụng Wallshare - Tạo ảnh bằng AI và chia sẻ mạng xã hội thời gian thực*
- 🏫 Trường Đại học Sài Gòn – Khoa Công nghệ Thông tin

---

## 📜 Giấy phép

Dự án này dùng cho mục đích học thuật. Không sử dụng thương mại.
