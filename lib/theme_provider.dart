
import 'package:flutter/foundation.dart';  
   
class DynamicTheme with ChangeNotifier {  
 // ChangeNotifier : will provide a notifier for any changes in the value to all it's listeners  
 bool isDarkMode = false;  
 getDarkMode() => this.isDarkMode;  
 void changeDarkMode(isDarkMode) {  
   this.isDarkMode = isDarkMode;  
   notifyListeners(); // Notify all it's listeners about update. If you comment this line then you will see that new added items will not be reflected in the list.  
 }  
} 
