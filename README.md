# lumment
A Java and C source code comment parser written in lua

# Setup
clone or download (and unzip) this repository  
install lua  5.1.5 (not tested on other versions)  

# Usage
to scan an entire tree use 
```shell
lua lumment.lua C:\Path\to\directorie\to\scan
``` 
or scan an entire tree relative to the location of lumment.lua
```shell
lua lumment.lua ..\directorie_to_scan
```
or scan the current directory even if lumment.lua isn't in there
```shell
lua relative_path\to\lumment.lua 
```
or scan some directory even if lumment.lua isn't in there
```shell
lua relative_path\to\lumment.lua relative_path\to\directorie
```
or use absolute paths
```shell
lua C:\path_to\lumment.lua C:\path\directorie
```

# Output
```
"..\\BlackjackCL\\blackjack.cpp" 5 26 " std::default_random_engine"
"..\\BlackjackCL\\blackjack.cpp" 6 26 " std::chrono::system_clock"
"..\\BlackjackCL\\blackjack.cpp" 27 2 "values"
"..\\BlackjackCL\\blackjack.cpp" 28 2 "0 1 2 3 4 5 6 7 8 9 10 11 12"
"..\\BlackjackCL\\blackjack.cpp" 29 2 "2 3 4 5 6 7 8 9 T J Q  K  A"
"..\\BlackjackCL\\blackjack.cpp" 43 31 "there are only 52 cards in a deck every number over 52 loops into the next deck of cards"
"..\\BlackjackCL\\blackjack.cpp" 44 32 "the cards are orderd every 13 cards a new suit starts"
```
Formatted as
|Path|line|offset|comment|
|----|----|------|-------|
|"..\\BlackjackCL\\blackjack.cpp"| 5| 26 |" std::default_random_engine"|
|"..\\BlackjackCL\\blackjack.cpp"| 6| 26 |" std::chrono::system_clock"
|"..\\BlackjackCL\\blackjack.cpp"| 27| 2 |"values"
|"..\\BlackjackCL\\blackjack.cpp"| 28| 2 |"0 1 2 3 4 5 6 7 8 9 10 11 12"
|"..\\BlackjackCL\\blackjack.cpp"| 29| 2 |"2 3 4 5 6 7 8 9 T J Q  K  A"
|"..\\BlackjackCL\\blackjack.cpp"| 43| 31|"there are only 52 cards in a deck every number over 52 loops into the next deck of cards"
|"..\\BlackjackCL\\blackjack.cpp"| 44| 32|"the cards are orderd every 13 cards a new suit starts"


# Test
test by running 
```shell
lua lumment.lua
```
it will print all comments contained in test.java and test-files/test.java

# References
Took the test files from https://github.com/g4s8/commentator/blob/c1e136ecd288dce27954f18e8644b8f574aebe51/test-files/test.java and changed it a bit