class AppSettings {
  bool isDarkMode = false;
  bool useCelsius = true;
  bool use24HourTime = true;

  void toggleTheme() => isDarkMode = !isDarkMode;
  void toggleTemperatureUnit() => useCelsius = !useCelsius;
  void toggleTimeFormat() => use24HourTime = !use24HourTime;
}