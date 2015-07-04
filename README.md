# todo_lint

[![Build Status](https://travis-ci.org/maxjacobson/todo_lint.svg)][travis]

[travis]: https://travis-ci.org/maxjacobson/todo_lint

Sometimes TODO comments stagnate over time and you forget about them. It would
be great if you could snooze them, Mailbox-style, and be reminded about them
again later.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todo_lint'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todo_lint

## Usage

Add this to your continuous integration list of commands in your `.travis.yml`
or `circle.yml`:

    bundle exec todo_lint

If you have a bunch of TODO comments in your code, your next build will fail.

Go through your TODO comments, and change from:

```ruby
# TODO: refactor into multiple classes
```

to:

```ruby
# TODO(2043-11-05): refactor into multiple classes
```

Now your build will pass. Until November, 2043.

## Configuration

Create a .todo_lint.yml file in your main repo

    Exclude Files:
      - vendor/**

Options include "Include Files:", "Exclude Files:", and "Extensions:"

If no extensions are specified, todo_lint will check all .rb files by default.

If you include files, todo_lint will only read those files.

The config file will exclude/include files starting from the directory where the config file is located

You may also configure your use of todo_lint from the command line:

    $ todo_lint -i .rb,.coffee,.js

Command flag              | Description
--------------------------|--------------------------------------------
`-c/--config [FILE]`      | Load the specified config file
`-e/--exclude [FILES]`    | Exclude the specified files
`-i/--include [EXTS]`     | Only look at specified extensions

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/maxjacobson/todo_lint. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.


## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

