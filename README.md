![logo](logo.png)
--

A dark and light theme for Jekyll, inspired by Dash UI for Atom. 🌒☀

![Build Tag](https://github.com/bitbrain/jekyll-dash/actions/workflows/build-tag.yml/badge.svg)
[![license](https://img.shields.io/github/license/bitbrain/jekyll-dash.svg?style=flat-square)](LICENSE.MD)
[![Gem](https://badgen.net/rubygems/v/jekyll-dash)](https://badgen.net/rubygems/v/jekyll-dash "View this project in Rubygems")
[![Downloads](https://ruby-gem-downloads-badge.herokuapp.com/jekyll-dash)](https://rubygems.org/gems/jekyll-dash "Number of Gem downloads")
---
This theme for [Jekyll](https://jekyllrb.com/) has been inspired by [dash-ui](https://atom.io/themes/dash-ui), a dark theme for [Atom](https://atom.io).

[![design](theme.gif)](http://bitbrain.github.io)

## Features

#### :first_quarter_moon: Dark/Light Mode
#### :arrow_left: Right-to-Left (RTL) Support
#### :bookmark: Tags
#### :orange_book: Pagination
#### :computer: Syntax Highlighting
#### :wave: Customisable Avatar Box
#### :two_hearts: Social Links

## Installation

Add this line to your Jekyll site's `Gemfile`:

For **Jekyll 3**:
```ruby
gem 'jekyll-dash', '~> 1'
```

> Keep in mind: Github pages generation [only supports Jekyll 3.9.x right now](https://pages.github.com/versions/).

For **Jekyll 4**:
```ruby
gem 'jekyll-dash', '~> 2'
```

And add this line to your Jekyll site's `_config.yml`:

```yaml
theme: jekyll-dash
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-dash -v version

## Configuration

Add the following configuration to your site. Customise it to your needs!

```yaml
# required by disqus to display comments
url: https://your-site-url

# jekyll-paginate
paginate: 5
paginate_path: "/blog/page:num/"

# jekyll-tagging (optional)
tag_permalink_style: pretty
tag_page_layout: tag_page
tag_page_dir: tag

# for github pages custom domains:
# include: [CNAME]

dash:
  # the way how dates should be displayed
  date_format: "%b %-d, %Y"

  # (optional) discqus comment configuration
  disqus:
    shortname: <your-disqus-shortname>  

  # the animation speed of the post scroll-in effect
  animation_speed: 50

  # wether to enable Right-to-Left support or not
  rtl: false

  # Replaces the default avatar provider (gravatar)
  #avatar_source: github
  #github_username: bitbrain
  #avatar_source: local
  #avatar_path: /assets/avatar.png

  # generate social links in footer
  # supported colors: green, red, orange, blue, cyan, pink, teal, yellow, indigo, purple
  social_links:
    - url: https://twitter.com/bitbrain_
      icon: twitter-square
      color: cyan
    - url: https://bitbrain.itch.io
      icon: itch-io
      color: red
    - url: https://github.com/bitbrain
      icon: github-square
      color: purple
  
  # wether the author box should be displayed or not
  show_author: true
```
## Using this theme directly on Github Pages

Please keep in mind that Github Pages does only support [a limited list of Jekyll plugins](https://pages.github.com/versions/). You will be able to use this theme on Github Pages but some functionality might not be available, for example displaying tags. In order to use this theme to a full extend, you have to generate the `_site` [separately via Github Actions](https://jekyllrb.com/docs/continuous-integration/github-actions/).

* `<username>.github.io` - contains main source branch and orphan gh-pages branch ([see example](https://github.com/bitbrain/bitbrain.github.io))

I have created [a guide on how to set this up here](https://bitbra.in/2021/10/03/host-your-own-blog-for-free-with-custom-domain.html).

You are not required to do this, but keep in mind that some functionality might not be available when using the Jekyll generator on Github directly!

If you are using a custom domain add in your main branch a file named CNAME with your domain there and uncomment this line in your config file:
```
include: [CNAME]
```
For more information about how to configure your CNAME file, read the [official documentation](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site).

## Additional Features

**Tagging** add the `jekyll/tagging` plugin to your `_config.yml` file to enable tagging. Do not forget to also add the following to your `Gemfile`:
```Gemfile
gem "jekyll-tagging"
```
**Gravatar** if you want to display your gravatar picture, add the `liquid-md5` to your `_config.yml` file. Do not forget to also add the following to your `Gemfile`:
```Gemfile
gem "liquid-md5"
```
## FAQ

> I have configured posts but no posts are showing?

**Solution:** You most probably forgot to configure [jekyll-paginate](https://jekyllrb.com/docs/pagination/) in your _config.yml! Make sure you have the correct configuration as described above!

> I have added the correct configuration for `jekyll-paginate` but it is now complaining about a missing `index.html` file. What do I do?

**Solution** pagination only works with HTML files! Markdown is not supported there. Simply rename your `index.md` into `index.html` - that should do the trick!

> I have configured Disqus via _config.yml but Disqus fails to load on the page? 

**Solution:** Make sure you configure the correct `url` within your `_config.yml`. Also make sure that your domain is trusted by Disqus. This can be configured within Disqus by adding a trusted domain.

> I am using this theme but I don't see any tags?

**Solution**: as described above you have to add the tagging plugin. Additionally, tags do not work natively by Github Pages. [You have to build your site on an external CI](https://bitbra.in/2021/10/03/host-your-own-blog-for-free-with-custom-domain.html) and push the `_site` artifacts to a hosting repository.

> I am getting an error that Bundler could not find compatible versions for gem

**Solution**

Make sure you are using a version of this theme that is compatible with Jekyll. Version 1.x is only compatible with Jekyll 3.x while Version 2.x is only compatible with Jekyll 4.x.

> I am getting an error 'cannot load such file --webrick' when trying to run `bundle exec jekyll serve`

**Solution**

As [explained here](https://github.com/jekyll/jekyll/issues/8523#issuecomment-751409319) this seems to be a bug with some recent Jekyll 4 version. To solve this simply run:
```bash
bundle add webrick
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bitbrain/jekyll-dash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Development

To set up your environment to develop this theme, run `bundle install`.

Your theme is setup just like a normal Jekyll site! To test your theme, run `bundle exec jekyll serve` and open your browser at `http://localhost:4000`. This starts a Jekyll server using your theme. Add pages, documents, data, etc. like normal to test your theme's contents. As you make modifications to your theme and to your content, your site will regenerate and you should see the changes in the browser after a refresh, just like normal.

When your theme is released, only the files in `_layouts`, `_includes`, `_sass` and `assets` tracked with Git will be bundled.
To add a custom directory to your theme-gem, please edit the regexp in `jekyll-dash.gemspec` accordingly.

> If you want to learn how Jekyll Dash gets deployed via Github Actions, feel free [to read this article](https://bitbra.in/2021/10/05/workflow-of-releasing-gem-based-jekyll-theme.html) written by me.

## License

The theme is available as open source under the terms of the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
