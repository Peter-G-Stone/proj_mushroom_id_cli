# ProjMushroomIdCli

The CLI allows you to retrieve information from foragingguide.com's 'in season mushrooms' page. Once the page has been scraped, there are ~60 instances of a Mushroom class containing a good deal of information about indentification. The CLI allows you to print descriptions of individual mushrooms, print all the mushrooms' descriptions, or get a link to an individual mushroom's foragingguide.com profile page. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proj_mushroom_id_cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proj_mushroom_id_cli

## Usage

Major commands in the interface:
"read intro" - prints a custom intro
"all" - prints all mushroom info
"select" - prints list of mushrooms, allows you to select one and displays that one's info
"link" - prints list of mushrooms, allows you to select one and displays that one's link
"exit" - exits program

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/<Peter-G-Stone>/proj_mushroom_id_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ProjMushroomIdCli project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/<Peter-G-Stone>/proj_mushroom_id_cli/blob/master/CODE_OF_CONDUCT.md).
