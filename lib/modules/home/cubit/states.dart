abstract class HomeStates {}

class HomeInitState extends HomeStates {}

class HomeSendMessageLoadingState extends HomeStates {}

class HomeSendMessageSuccessState extends HomeStates {}

class HomeSendMessageErrorState extends HomeStates {
  String error;
  HomeSendMessageErrorState(this.error);
}

class HomeGetMessagesLoadingState extends HomeStates {}

class HomeGetMessagesSuccessState extends HomeStates {}

class HomeGetMessagesErrorState extends HomeStates {
  String error;
  HomeGetMessagesErrorState(this.error);
}

class HomeGetSendMessagesLoadingState extends HomeStates {}

class HomeGetSendMessagesSuccessState extends HomeStates {}

class HomeGetSendMessagesErrorState extends HomeStates {
  String error;
  HomeGetSendMessagesErrorState(this.error);
}

class HomeFavorateSuccessState extends HomeStates {}

class HomeGetFavoratesSuccessState extends HomeStates {}

class HomeSelectImageSuccessState extends HomeStates {}
