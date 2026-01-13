import './supabase_service.dart';

class LearningPathService {
  Future<Map<String, dynamic>> getLearningPath() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated. Please sign in first.');
    }

    final response = await supabase.rpc(
      'get_learning_path',
      params: {'p_auth_user_id': currentUser.id},
    );
    return response as Map<String, dynamic>;
  }
}
