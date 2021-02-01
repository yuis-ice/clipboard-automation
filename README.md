
# clipboard automation

✓ This is beta version release and under some bugs

<!-- ![http://yuis.xsrv.jp/data/Screenshot_20210202-013526.png](http://yuis.xsrv.jp/data/Screenshot_20210202-013526.png) -->
<!-- ![http://yuis.xsrv.jp/data/Screenshot_20210202-013529.png](http://yuis.xsrv.jp/data/Screenshot_20210202-013529.png) -->
<img src="http://yuis.xsrv.jp/data/Screenshot_20210202-013526.png" width="250"/>
<!-- <img src="http://yuis.xsrv.jp/data/Screenshot_20210202-013529.png" width="250"/> -->

## Features

- copy computer's clipboard to your android (and iOS) device
- vibration enable/disable
- copy enable/disable
- auto open as html file

## Quick Start

- For android

Download and install the apk onto your Android phone here: [app.apk](https://github.com/yuis-ice/clipboard-automation/releases/download/tmp/app.apk)

- For your PC

This creates WebSocket server and listen for clipboard and send them to the app.

```sh
git clone https://github.com/yuis-ice/clipboard-automation.git
cd clipboard-automation
cd node-client
npm i
node client.js
```

For node.js installation

```sh
# node.js [nvm-sh/nvm](https://github.com/nvm-sh/nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
bash
nvm install v13.10.1
node -v
```

## Build apk from source code

Install Flutter first, then:

```sh
git clone https://github.com/yuis-ice/clipboard-automation.git
cd clipboard-automation
flutter clean
flutter build apk
```

## (misc)

This repo is currently review version and mainly for my acquaintance rather than part of my portfolio. please kindly not to share the repo publicly for now.

```yaml

todos:
  modifiable WebSocket port number, app side, node side
  update the message when WebSocket successfully/unsuccessfully connected to the server
  auto open as url
  modifiable filename with extension for the auto open as file

```
