import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/learning_path.dart';
import '../services/supabase/learning_path_service.dart';

part 'learning_path_provider.g.dart';

@riverpod
LearningPathService learningPathService(Ref ref) {
  return LearningPathService();
}

@riverpod
Future<LearningPath> learningPath(Ref ref) async {
  final service = ref.watch(learningPathServiceProvider);
  final data = await service.getLearningPath();
  return LearningPath.fromJson(data);
}
