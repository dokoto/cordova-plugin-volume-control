var exec = require('cordova/exec');

function defaults(object, source) {
  if(!object) object = {};
  for(var prop in source) {
    if(typeof object[prop] === 'undefined') {
      object[prop] = source[prop];
    }
  }
  return object;
}

exports.setVolumeAfterHideHUD = function(volume, success, error) {
  if (volume > 1) {
    volume /= 100;
  }
  exec(success, error, 'VolumeControl', 'setVolumeAfterHideHUD', [volume * 1]);
};

exports.setVolumeBeforeShowHUD = function(volume, success, error) {
  if (volume > 1) {
    volume /= 100;
  }
  exec(success, error, 'VolumeControl', 'setVolumeBeforeShowHUD', [volume * 1]);
};
