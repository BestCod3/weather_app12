class WeatherData {
  static calculateWeather(double kelvin) {
    final data = (kelvin - 273.15).toStringAsFixed(0);
    return data;
  }

  static getDescription(num temp) {
    if (temp > 25) {
      return 'High temperature 🔥';
    } else if (temp > 20) {
      return 'It\'s relatively \n       hot 🌞';
    } else if (temp < 10) {
      return 'Regarding \n     heat ⛅';
    } else if (temp > 10) {
      return 'Bring a 🧥 \njust in case';
    } else {
      return 'Really cold\n or hot';
    }
  }

  static getWeatherIcon(num temp) {
    if (temp > 18) {
      return '☀️';
    } else if (temp >= 10) {
      return '⛅';
    } else if (temp < 0 - 10) {
      return '🌧';
    } else if (temp < 20) {
      return '☔️';
    } else {
      return '🤷';
    }
  }
}
