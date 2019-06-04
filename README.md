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
  "ApiKey": "TINYPNG_API_KEY,
  "minSize": 500000
},

"upload": {
  "image": "path/to/uploaded/images"
},
```

## Use

Copy ./node_modules/abe-tinypng/custom to rootFolder custom

Now on the backoffice there will be a button on the left `Start Tinypng` to launch Tinypng script
