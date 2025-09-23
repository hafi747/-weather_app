part of 'weather_bloc_bloc.dart';

@immutable
sealed class WeatherBlocState {}

final class WeatherBlocInitial extends WeatherBlocState {}

final class WeatherBlocLoading extends WeatherBlocState {}

final class WeatherBlocSuccess extends WeatherBlocState {
  final Weather weather;
  WeatherBlocSuccess(this.weather);
}

final class WeatherBlocFailure extends WeatherBlocState {
  final String message;
  WeatherBlocFailure(this.message);
}
