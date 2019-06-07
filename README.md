# Abe-tinypng

## Install

package.json
```
"dependencies": {
  "abe-tinypng": "github:ADFABNorthAmericaInc/abe-tinypng"
},
```

then `npm i`

## Config

abe.json
```
"tinpypng": {
  "ApiKey": "TINYPNG_API_KEY",
  "minSize": "+500k",
  "sleepTime": "30s",
  "sleepCount": 50
},

"upload": {
  "image": "path/to/uploaded/images"
},
```

- ApiKey: your tinpypng api key
- minSize: file which are over this size parameter will be optimized
- sleepTime: time to sleep after `sleepCount` has been reach
- sleepCount: number of file to curl with tinpypng before to sleep (`sleepTime` to not create stuff like DDoS attack)

## Use

Copy ./node_modules/abe-tinypng/custom to rootFolder custom

Now on the backoffice there will be a button on the left `Start Tinypng` to launch Tinypng script
