const GoogleStrategy = require('passport-google-oauth20').Strategy;
const GithubStrategy = require('passport-github2').Strategy;
const FacebookStrategy = require('passport-facebook').Strategy;

const passport = require("passport");
const GOOGLE_CLIENT_ID = "668155213175-56rc25as4lme6jn7jo5pa0v6accagach.apps.googleusercontent.com"
const GOOGLE_CLIENT_SECRET = "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"


GITHUB_CLIENT_ID = "aa2b070a456a5e8d0fd5";
GITHUB_CLIENT_SECRET = "69628f4dee30167066a544c876e47c5bcde75617";

FACEBOOK_CLIENT_ID = "aa2b070a456a5e8d0fd5";
FACEBOOK_CLIENT_SECRET = "69628f4dee30167066a544c876e47c5bcde75617";


passport.use(
    new GoogleStrategy(
      {
        clientID: GOOGLE_CLIENT_ID,
        clientSecret: GOOGLE_CLIENT_SECRET,
        callbackURL: "/auth/google/callback",
      },
      function (accessToken, refreshToken, profile, done) {
        done(null, profile);
        
      }
    )
  );

  passport.use(
    new GithubStrategy(
      {
        clientID: GITHUB_CLIENT_ID,
        clientSecret: GITHUB_CLIENT_SECRET,
        callbackURL: "/auth/github/callback",
      },
      function (accessToken, refreshToken, profile, done) {
        done(null, profile);
        
      }
    )
  );

  passport.serializeUser((user,done)=>{
    done(null,user);
  });

  passport.deserializeUser((user,done)=>{
    done(null,user);
  });