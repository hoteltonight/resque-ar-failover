<img src="https://raw.github.com/hoteltonight/HTDelegateProxy/master/ht-logo-black.png" alt="HotelTonight" title="HotelTonight" style="display:block; margin: 10px auto 30px auto;">

# resque-ar-failover

Resque plugin to fail over to ActiveRecord backend for Resque job storage, when Redis is unavailable.

## Background

At HotelTonight we use Redis. We love it. We also love Resque. But every once in a while,
Redis goes away for a split second, causing issues in our app and making some jobs to
fall through the cracks.

## resque-ar-failover

Resque-ar-failover deals with this issue by rescueing the exceptions that signal that `Resque.enqueue` has failed
before being able to contact redis. When that happens, we persist the job to our MySQL backend (which is HA ready).

We use MySQL; you don't have to. Any AR adapter will do.

## Installation

Resque-AR-failover is distributed as a gem. Just drop it in your `Gemfile`

```
gem 'resque-ar-failover'
```

Then make sure you add [this migration][migration] to your project or run the following command to create the migration automatically.

```
rails generate resque_ar_failover install
rake db:migrate
```

And that's it! If redis goes down a new `ResqueBackup` entry will be added and it will automatically be picked up by your resque workers.

## License

Check out the [LICENSE][license] file.

 [migration]: https://github.com/hoteltonight/resque-ar-failover/master/lib/generators/templates/migration.rb
 [license]: https://github.com/hoteltonight/resque-ar-failover/master/LICENSE
