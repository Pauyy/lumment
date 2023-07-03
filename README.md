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

# Test
test by running 
```shell
lua lumment.lua
```
it will print all comments contained in test.java and test-files/test.javaS

# References
Took the test files from https://github.com/g4s8/commentator/blob/c1e136ecd288dce27954f18e8644b8f574aebe51/test-files/test.java and changed it a bit