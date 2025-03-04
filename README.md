# jsonfmt.sh
Format JSON with POSIX Shell

# Usage
```sh
printf '%s\n' '{"num":-0.123e+5,"str":"hello world!","obj":{"key":1},"arr":[1,"aab",null],"escape":"\"\\\/\b\f\n\r\t\u002f","bool": true}' | ./jsonfmt.sh
```
