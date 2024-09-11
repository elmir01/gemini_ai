import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_ai/viewmodel/home_viewmodel.dart';

var homeViewModel = ChangeNotifierProvider((ref) => HomeViewModel());