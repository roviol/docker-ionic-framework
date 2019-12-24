# ionic-framework


## Usage

### Use shell with ionic

`docker run -it --rm -v $(pwd):/myApp roviol/ionic-framework bash`

### Build APK

`docker run -it --rm -v $(pwd):/myApp roviol/ionic-framework ionic cordova build android`

### Setting

* NODE_VERSION=10.13.0
* NPM_VERSION=6.4.1
* IONIC_VERSION=5.4.13
* CORDOVA_VERSION=9.0.0
* GRADLE_VERSION=5.6.4
* android-28
* build-tools;29.0.2
