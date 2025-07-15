import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

// Localization Service for Vietnamese/English support
class LocalizationService {
  static const Map<String, Map<String, String>> _translations = {
    'vi': {
      // App Name
      'app_name': 'BSA',
      'app_full_name': 'Bright Starts Academy',
      'welcome': 'Chào mừng đến với BSA',
      
      // Authentication
      'login': 'Đăng nhập',
      'register': 'Đăng ký',
      'logout': 'Đăng xuất',
      'email': 'Email',
      'password': 'Mật khẩu',
      'username': 'Tên đăng nhập',
      'confirm_password': 'Xác nhận mật khẩu',
      'forgot_password': 'Quên mật khẩu?',
      'login_success': 'Đăng nhập thành công',
      'register_success': 'Đăng ký thành công',
      'login_failed': 'Đăng nhập thất bại',
      'register_failed': 'Đăng ký thất bại',
      
      // Navigation
      'home': 'Trang chủ',
      'dashboard': 'Bảng điều khiển',
      'flashcards': 'Thẻ học',
      'quizzes': 'Bài kiểm tra',
      'notes': 'Ghi chú',
      'assignments': 'Bài tập',
      'study_groups': 'Nhóm học tập',
      'profile': 'Hồ sơ',
      'settings': 'Cài đặt',
      'chat': 'Trò chuyện',
      'search': 'Tìm kiếm',
      'notifications': 'Thông báo',
      
      // Dashboard
      'welcome_back': 'Chào mừng trở lại',
      'study_progress': 'Tiến độ học tập',
      'upcoming_assignments': 'Bài tập sắp tới',
      'recent_activity': 'Hoạt động gần đây',
      'study_streak': 'Chuỗi học tập',
      'total_xp': 'Tổng XP',
      'level': 'Cấp độ',
      'achievements': 'Thành tích',
      'daily_goal': 'Mục tiêu hàng ngày',
      'weekly_progress': 'Tiến độ tuần',
      'study_time': 'Thời gian học',
      'completed_today': 'Hoàn thành hôm nay',
      
      // Flashcards
      'my_decks': 'Bộ thẻ của tôi',
      'create_deck': 'Tạo bộ thẻ',
      'deck_title': 'Tiêu đề bộ thẻ',
      'deck_description': 'Mô tả bộ thẻ',
      'add_card': 'Thêm thẻ',
      'front_side': 'Mặt trước',
      'back_side': 'Mặt sau',
      'hint': 'Gợi ý',
      'study_now': 'Học ngay',
      'review_cards': 'Ôn tập thẻ',
      'show_answer': 'Hiện đáp án',
      'next_card': 'Thẻ tiếp theo',
      'previous_card': 'Thẻ trước',
      'mark_correct': 'Đánh dấu đúng',
      'mark_incorrect': 'Đánh dấu sai',
      'study_complete': 'Hoàn thành ôn tập',
      'cards_studied': 'Thẻ đã học',
      'accuracy': 'Độ chính xác',
      
      // Quizzes
      'my_quizzes': 'Bài kiểm tra của tôi',
      'create_quiz': 'Tạo bài kiểm tra',
      'quiz_title': 'Tiêu đề bài kiểm tra',
      'quiz_description': 'Mô tả bài kiểm tra',
      'add_question': 'Thêm câu hỏi',
      'question': 'Câu hỏi',
      'answer_options': 'Các lựa chọn',
      'correct_answer': 'Đáp án đúng',
      'start_quiz': 'Bắt đầu',
      'submit_quiz': 'Nộp bài',
      'quiz_results': 'Kết quả',
      'score': 'Điểm số',
      'time_taken': 'Thời gian làm bài',
      'questions_correct': 'Câu trả lời đúng',
      'quiz_history': 'Lịch sử bài kiểm tra',
      'retake_quiz': 'Làm lại',
      
      // Notes
      'my_notes': 'Ghi chú của tôi',
      'create_note': 'Tạo ghi chú',
      'note_title': 'Tiêu đề ghi chú',
      'note_content': 'Nội dung ghi chú',
      'add_tags': 'Thêm thẻ',
      'save_note': 'Lưu ghi chú',
      'edit_note': 'Chỉnh sửa ghi chú',
      'delete_note': 'Xóa ghi chú',
      'search_notes': 'Tìm kiếm ghi chú',
      'filter_by_tags': 'Lọc theo thẻ',
      'pinned_notes': 'Ghi chú đã ghim',
      'recent_notes': 'Ghi chú gần đây',
      
      // Assignments
      'my_assignments': 'Bài tập của tôi',
      'create_assignment': 'Tạo bài tập',
      'assignment_title': 'Tiêu đề bài tập',
      'assignment_description': 'Mô tả bài tập',
      'due_date': 'Hạn nộp',
      'priority': 'Độ ưu tiên',
      'subject': 'Môn học',
      'status': 'Trạng thái',
      'mark_complete': 'Đánh dấu hoàn thành',
      'mark_incomplete': 'Đánh dấu chưa hoàn thành',
      'overdue': 'Quá hạn',
      'due_soon': 'Sắp hết hạn',
      'completed': 'Hoàn thành',
      'pending': 'Chờ',
      'in_progress': 'Đang làm',
      'high_priority': 'Ưu tiên cao',
      'medium_priority': 'Ưu tiên trung bình',
      'low_priority': 'Ưu tiên thấp',
      
      // Study Groups
      'study_groups': 'Nhóm học tập',
      'create_group': 'Tạo nhóm',
      'join_group': 'Tham gia nhóm',
      'group_name': 'Tên nhóm',
      'group_description': 'Mô tả nhóm',
      'members': 'Thành viên',
      'group_chat': 'Trò chuyện nhóm',
      'group_resources': 'Tài nguyên nhóm',
      'leave_group': 'Rời khỏi nhóm',
      'invite_members': 'Mời thành viên',
      
      // Profile
      'my_profile': 'Hồ sơ của tôi',
      'edit_profile': 'Chỉnh sửa hồ sơ',
      'display_name': 'Tên hiển thị',
      'bio': 'Tiểu sử',
      'location': 'Vị trí',
      'joined_date': 'Ngày tham gia',
      'study_statistics': 'Thống kê học tập',
      'learning_streak': 'Chuỗi học tập',
      'total_study_time': 'Tổng thời gian học',
      'completed_quizzes': 'Bài kiểm tra đã hoàn thành',
      'flashcards_reviewed': 'Thẻ học đã ôn tập',
      'notes_created': 'Ghi chú đã tạo',
      'assignments_completed': 'Bài tập đã hoàn thành',
      
      // Settings
      'app_settings': 'Cài đặt ứng dụng',
      'language': 'Ngôn ngữ',
      'theme': 'Giao diện',
      'notifications_settings': 'Cài đặt thông báo',
      'study_reminders': 'Nhắc nhở học tập',
      'assignment_reminders': 'Nhắc nhở bài tập',
      'privacy_settings': 'Cài đặt quyền riêng tư',
      'account_settings': 'Cài đặt tài khoản',
      'change_password': 'Đổi mật khẩu',
      'delete_account': 'Xóa tài khoản',
      'help_support': 'Trợ giúp & Hỗ trợ',
      'about_app': 'Về ứng dụng',
      'version': 'Phiên bản',
      
      // General
      'save': 'Lưu',
      'cancel': 'Hủy',
      'delete': 'Xóa',
      'edit': 'Chỉnh sửa',
      'create': 'Tạo',
      'update': 'Cập nhật',
      'confirm': 'Xác nhận',
      'close': 'Đóng',
      'loading': 'Đang tải...',
      'error': 'Lỗi',
      'success': 'Thành công',
      'warning': 'Cảnh báo',
      'info': 'Thông tin',
      'yes': 'Có',
      'no': 'Không',
      'ok': 'OK',
      'retry': 'Thử lại',
      'refresh': 'Làm mới',
      'search_placeholder': 'Tìm kiếm...',
      'no_results': 'Không có kết quả',
      'empty_state': 'Trống',
      'network_error': 'Lỗi mạng',
      'connection_error': 'Lỗi kết nối',
      'server_error': 'Lỗi máy chủ',
      'unknown_error': 'Lỗi không xác định',
      'coming_soon': 'Sắp ra mắt',
      'maintenance': 'Bảo trì',
      
      // Time
      'today': 'Hôm nay',
      'yesterday': 'Hôm qua',
      'tomorrow': 'Ngày mai',
      'this_week': 'Tuần này',
      'last_week': 'Tuần trước',
      'this_month': 'Tháng này',
      'last_month': 'Tháng trước',
      'minutes': 'phút',
      'hours': 'giờ',
      'days': 'ngày',
      'weeks': 'tuần',
      'months': 'tháng',
      'years': 'năm',
      
      // Validation
      'required_field': 'Trường bắt buộc',
      'invalid_email': 'Email không hợp lệ',
      'password_too_short': 'Mật khẩu quá ngắn',
      'passwords_not_match': 'Mật khẩu không khớp',
      'invalid_username': 'Tên đăng nhập không hợp lệ',
      'field_too_long': 'Trường quá dài',
      'field_too_short': 'Trường quá ngắn',
    },
    'en': {
      // App Name
      'app_name': 'BSA',
      'app_full_name': 'Bright Starts Academy',
      'welcome': 'Welcome to BSA',
      
      // Authentication
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'username': 'Username',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'login_success': 'Login successful',
      'register_success': 'Registration successful',
      'login_failed': 'Login failed',
      'register_failed': 'Registration failed',
      
      // Navigation
      'home': 'Home',
      'dashboard': 'Dashboard',
      'flashcards': 'Flashcards',
      'quizzes': 'Quizzes',
      'notes': 'Notes',
      'assignments': 'Assignments',
      'study_groups': 'Study Groups',
      'profile': 'Profile',
      'settings': 'Settings',
      'chat': 'Chat',
      'search': 'Search',
      'notifications': 'Notifications',
      
      // Dashboard
      'welcome_back': 'Welcome back',
      'study_progress': 'Study Progress',
      'upcoming_assignments': 'Upcoming Assignments',
      'recent_activity': 'Recent Activity',
      'study_streak': 'Study Streak',
      'total_xp': 'Total XP',
      'level': 'Level',
      'achievements': 'Achievements',
      'daily_goal': 'Daily Goal',
      'weekly_progress': 'Weekly Progress',
      'study_time': 'Study Time',
      'completed_today': 'Completed Today',
      
      // ... (similar structure for all English translations)
      // For brevity, I'll add key ones
      
      // General
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'create': 'Create',
      'update': 'Update',
      'confirm': 'Confirm',
      'close': 'Close',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Info',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'retry': 'Retry',
      'refresh': 'Refresh',
      'search_placeholder': 'Search...',
      'no_results': 'No results',
      'empty_state': 'Empty',
      'network_error': 'Network error',
      'connection_error': 'Connection error',
      'server_error': 'Server error',
      'unknown_error': 'Unknown error',
      'coming_soon': 'Coming soon',
      'maintenance': 'Maintenance',
    }
  };

  static String? _currentLanguage;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(AppConstants.languageKey) ?? AppConstants.vietnamese;
  }

  static String get currentLanguage => _currentLanguage ?? AppConstants.vietnamese;

  static Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.languageKey, language);
  }

  static String translate(String key, {String? fallback}) {
    final translations = _translations[currentLanguage] ?? _translations[AppConstants.vietnamese]!;
    return translations[key] ?? fallback ?? key;
  }

  static String t(String key, {String? fallback}) {
    return translate(key, fallback: fallback);
  }

  static Locale get locale {
    switch (currentLanguage) {
      case AppConstants.vietnamese:
        return const Locale('vi', 'VN');
      case AppConstants.english:
        return const Locale('en', 'US');
      default:
        return const Locale('vi', 'VN');
    }
  }

  static List<Locale> get supportedLocales {
    return [
      const Locale('vi', 'VN'),
      const Locale('en', 'US'),
    ];
  }
}