/**
 * @author jakelammers & claude 3.5
 * @date 10-24-24
 *
 * settings model for the settings page
 */
class AppSettings {
  bool isDarkMode = false;
  bool useCelsius = true;
  bool use24HourTime = true;

  void toggleTheme() => isDarkMode = !isDarkMode;
  void toggleTemperatureUnit() => useCelsius = !useCelsius;
  void toggleTimeFormat() => use24HourTime = !use24HourTime;
}