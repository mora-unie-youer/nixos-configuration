/*** [SECTION 9999]: USER CONFIGURATION
 * [WHY] User also wants to integrate something in code
 ***/
user_pref("browser.startup.page", 3);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("privacy.sanitize.sanitizeOnShutdown", false);

user_pref(
  "privacy.resistFingerprinting.exemptedDomains",
  "*.twitch.tv,twitch.tv",
);

user_pref("browser.uidensity", 1);
user_pref("devtools.toolbox.host", "window");
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("sidebar.position_start", false);

user_pref("xpinstall.signatures.required", false);
