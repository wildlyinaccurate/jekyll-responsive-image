# jekyll-responsive-image

A [Jekyll](http://jekyllrb.com/) plugin for automatically resizing images. Fully configurable and unopinionated, jekyll-responsive-image allows you to display responsive images however you like: using [`<img srcset>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Img#attr-srcset), [`<picture>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/picture), or [Imager.js](https://github.com/BBC-News/Imager.js/).

[![Build Status](https://img.shields.io/travis/wildlyinaccurate/jekyll-responsive-image.svg?style=flat-square)](https://travis-ci.org/wildlyinaccurate/jekyll-responsive-image)
[![Coverage Status](https://img.shields.io/coveralls/wildlyinaccurate/jekyll-responsive-image.svg?style=flat-square)](https://coveralls.io/repos/github/wildlyinaccurate/jekyll-responsive-image/badge.svg?branch=master)

## Installation

This plugin can be installed in three steps:

### 1. Install the gem

Either add `jekyll-responsive-image` to your Gemfile, or run the following command to install the gem:

```
$ gem install jekyll-responsive-image
```

Then you can either add `jekyll-responsive-image` to the `gems` section of your `_config.yml`:

```yaml
gems:
  - jekyll-responsive-image
```

Or you can copy the contents of [`responsive_image.rb`](lib/jekyll-responsive-image.rb) into your `_plugins` directory.

### 2. Create an image template file

You will need to create a template in order to use the `responsive_image` and `responsive_image_block` tags. Normally the template lives in your `_includes/` directory. Not sure where to start? [Take a look at the sample templates](sample-templates).

For more advanced templates, see the [**Templates**](#templates) section below.

### 3. Configure the plugin

You **must** have a `responsive_image` block in your `_config.yml` for this plugin to work. The minimum required configuration is a `template` path:

```yaml
responsive_image:
  template: _includes/responsive-image.html
```

For a list of all the available configuration options, see the [**All configuration options**](#all-configuration-options) section below.

## Usage

Replace your images with the `responsive_image` tag, specifying the path to the image in the `path` attribute.

```twig
{% responsive_image path: assets/my-file.jpg %}
```

You can override the template on a per-image basis by specifying the `template` attribute.

```twig
{% responsive_image path: assets/my-file.jpg template: _includes/another-template.html %}
```

Any extra attributes will be passed straight to the template as variables.

```twig
{% responsive_image path: assets/image.jpg alt: "Lorem ipsum..." title: "Lorem ipsum..." %}
```

### Liquid variables as attributes

You can use Liquid variables as attributes with the `responsive_image_block` tag. This tag works in exactly the same way as the `responsive_image` tag, but is implemented as a block tag to allow for more complex logic.

> **Important!** The attributes in the `responsive_image_block` tag are parsed as YAML, so whitespace and indentation are significant!

```twig
{% assign path = 'assets/test.png' %}
{% assign alt = 'Lorem ipsum...' %}

{% responsive_image_block %}
  path: {{ path }}
  alt: {{ alt }}
  {% if title %}
  title: {{ title }}
  {% endif %}
{% endresponsive_image_block %}
```

## Templates

It's easy to build your own custom templates to render images however you want using the template variables provided by jekyll-responsive-image.

### Template Variables

The following variables are available in the template:

| Variable   | Type          | Description                                                                                          |
|------------|---------------|------------------------------------------------------------------------------------------------------|
| `path`     | String        | The path of the unmodified image. This is always the same as the `path` attribute passed to the tag. |
| `resized`  | Array<Object> | An array of all the resized images. Each image is an **Image Object**.                               |
| `original` | Object        | An **Image Object** containing information about the original image.                                 |
| `*`        | String        | Any other attributes will be passed to the template verbatim as strings (see below).                 |

Any other attributes that are given to the `responsive_image` or `responsive_image_block` tags will be available in the template. For example the following tag will provide an `{{ alt }}` variable to the template:

```twig
{% responsive_image path: assets/my-file.jpg alt: "A description of the image" %}
```

#### Image Objects

Image objects (like `original` and each object in `resized`) contain the following properties:

| Variable    | Type    | Description                                                                                  |
|-------------|---------|----------------------------------------------------------------------------------------------|
| `path`      | String  | The path to the image.                                                                       |
| `width`     | Integer | The width of the image.                                                                      |
| `height`    | Integer | The height of the image.                                                                     |
| `basename`  | String  | Basename of the file (`assets/some-file.jpg` => `some-file.jpg`).                            |
| `dirname`   | String  | Directory of the file relative to `base_path` (`assets/sub/dir/some-file.jpg` => `sub/dir`). |
| `filename`  | String  | Basename without the extension (`assets/some-file.jpg` => `some-file`).                      |
| `extension` | String  | Extension of the file (`assets/some-file.jpg` => `jpg`).                                     |

## All configuration options

A full list of all of the available configuration options is below.

```yaml
responsive_image:
  # [Required]
  # Path to the image template.
  template: _includes/responsive-image.html

  # [Optional, Default: 85]
  # Quality to use when resizing images.
  default_quality: 90

  # [Optional, Default: []]
  # An array of resize configuration objects. Each object must contain at least
  # a `width` value.
  sizes:
    - width: 480  # [Required] How wide the resized image will be.
      quality: 80 # [Optional] Overrides default_quality for this size.
    - width: 800
    - width: 1400
      quality: 90

  # [Optional, Default: false]
  # Rotate resized images depending on their EXIF rotation attribute. Useful for
  # working with JPGs directly from digital cameras and smartphones
  auto_rotate: false

  # [Optional, Default: false]
  # Strip EXIF and other JPEG profiles. Helps to minimize JPEG size and win friends
  # at Google PageSpeed.
  strip: false

  # [Optional, Default: assets]
  # The base directory where assets are stored. This is used to determine the
  # `dirname` value in `output_path_format` below.
  base_path: assets

  # [Optional, Default: assets/resized/%{filename}-%{width}x%{height}.%{extension}]
  # The template used when generating filenames for resized images. Must be a
  # relative path.
  #
  # Parameters available are:
  #   %{dirname}     Directory of the file relative to `base_path` (assets/sub/dir/some-file.jpg => sub/dir)
  #   %{basename}    Basename of the file (assets/some-file.jpg => some-file.jpg)
  #   %{filename}    Basename without the extension (assets/some-file.jpg => some-file)
  #   %{extension}   Extension of the file (assets/some-file.jpg => jpg)
  #   %{width}       Width of the resized image
  #   %{height}      Height of the resized image
  #
  output_path_format: assets/resized/%{width}/%{basename}

  # [Optional, Default: true]
  # Whether or not to save the generated assets into the source folder.
  save_to_source: false

  # [Optional, Default: false]
  # Cache the result of {% responsive_image %} and {% responsive_image_block %}
  # tags. See the "Caching" section of the README for more information.
  cache: false

  # [Optional, Default: []]
  # By default, only images referenced by the responsive_image and responsive_image_block
  # tags are resized. Here you can set a list of paths or path globs to resize other
  # images. This is useful for resizing images which will be referenced from stylesheets.
  extra_images:
    - assets/foo/bar.png
    - assets/bgs/*.png
    - assets/avatars/*.{jpeg,jpg}
```

## Caching

You may be able to speed up the build of large sites by enabling render caching. This is usually only effective when the same image is used many times, for example a header image that is rendered in every post.

The recommended way to enable caching is on an image-by-image basis, by adding `cache: true` to the tag:

```twig
{% responsive_image path: 'assets/my-file.jpg' cache: true %}

{% responsive_image_block %}
    path: assets/my-file.jpg
    cache: true
{% endresponsive_image_block %}
```

You can also enable it for all images by adding `cache: true` to your `_config.yml`:

```yaml
responsive_image:
  cache: true
  template: _includes/responsive-image.html
  sizes:
    - ...
```
