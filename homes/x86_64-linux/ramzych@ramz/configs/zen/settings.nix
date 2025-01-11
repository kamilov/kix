{
  # search settings
  "browser.search.region" = "RU";
  "browser.search.defaultenginename" = "Google";
  "browser.urlbar.placeholderName" = "Google";
  "keyword.enabled" = true;

  # urlbar
  "browser.urlbar.suggest.clipboard" = false;
  "browser.urlbar.suggest.engines" = false;
  "browser.urlbar.suggest.history" = false;
  "browser.urlbar.suggest.openpage" = false;
  "browser.urlbar.suggest.recentsearches" = false;
  "browser.urlbar.suggest.topsites" = false;

  # privacy
  "privacy.sanitize.sanitizeOnShutdown" = false; # ?
  "privacy.clearOnShutdown.downloads" = false;
  "privacy.clearOnShutdown.history" = true;
  "dom.security.https_only_mode" = true; # HTTPS only mode
  "network.cookie.lifetimePolicy" = 0; # keep cookies between restart

  # misc
  "browser.safebrowsing.passwords.enabled" = true; # save passwords in safebrowsing mode
  "services.sync.engine.passwords" = false; # do not sync passwords
  "browser.sessionstore.resume_session_once" = true; # ?
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # ?

  # performance
  # https://www.reddit.com/r/browsers/comments/nugbaw/firefox_going_up_to_1000_mb_with_only_5_tabs_open/
  "dom.ipc.processCount" = 0;
  "dom.ipc.processPrelaunch.enabled" = false;
  "dom.ipc.keepProcessesAlive.privilegedabout" = 0;
  "dom.webgpu.enabled" = true;

  # network
  "media.peerconnection.enabled" = false; # disable vpn detection through webrtc

  # mouse
  "mousewheel.default.delta_multiplier_x" = 250;
  "mousewheel.default.delta_multiplier_y" = 250;
  "mousewheel.with_shift.delta_multiplier_y" = 250;

  # sidebar
  "zen.view.sidebar-expanded" = false;
  "zen.view.sidebar-expanded.on-hover" = true;
}
