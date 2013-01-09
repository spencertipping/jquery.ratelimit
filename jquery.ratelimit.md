Rate-limited events | Spencer Tipping
Licensed under the terms of the MIT source code license
(Or GPL if you prefer)

# Introduction

jQuery events are normally synchronous, which is a problem if you need to do
something CPU-bound after each one. As an approximation, a lot of apps will
instead use rate-limiting, which entails waiting some number of milliseconds
before committing to the CPU-bound action. If another event interrupts the
flow, the action is deferred; so nothing happens until two events are spaced
more than a certain amount of time apart.

This module provides a function to help with this:

    jQuery.rateLimited({options}, f)              // return rate-limited f

All data is stored on the function object itself under a key that can be
customized.

# Options

The `options` object is optional and has these fields:

    delay (250)                   number of milliseconds to wait
    key   ('rateLimitState')      property name for state

The `key` property is used internally to associate function-specific state.

    (function ($) {
      $.rateLimited = function (options, f) {
        if (!f) f = options, options = null;

        var settings = $.extend({}, $.rateLimited.defaults, options);
        var delay    = options.delay;
        var stateKey = options.key;
        var result = function () {
          var timeout = result[stateKey];
          var self    = this;
          var args    = arguments;
          if (timeout) clearTimeout(timeout);

          // Return the new timeout to make it easier to cancel things explicitly
          return result[stateKey] = setTimeout(function () {
            result[stateKey] = null;
            f.apply(self, args);
          }, delay);
        };

        return result;
      };

      $.rateLimited.defaults = {delay: 250, key: 'rateLimitState'};
    })(jQuery);
