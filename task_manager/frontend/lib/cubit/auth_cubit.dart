import 'package:bloc/bloc.dart';
import 'package:task_manager/model/user_model.dart';
import 'package:task_manager/repository/auth_remote_repo.dart';
import 'package:task_manager/services/services.dart';

part 'auth_state.dart';
class AuthCubit  extends Cubit<AuthState> {
AuthCubit() : super(AuthInitial());
final authRemoteRepository = AuthRemoteRepository();
final spService = SpService();
void getUserData() async{
  try{
    emit(AuthLoading());
    final userModel = await authRemoteRepository.getUserData();
    if(userModel != null){
      emit(AuthLoggedIn(userModel));
    }
    emit(AuthInitial());
  }catch(e){
    emit(AuthInitial());
  }
}
  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      await authRemoteRepository.signUp(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      if (userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }

      

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

